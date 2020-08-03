//
//  ResourceColumn.swift
//  RexEdit
//
//  Created by Daniel McManus on 8/2/20.
//

import SwiftUI

struct KeysColumn: View {
    var baseFilePath: String
    @EnvironmentObject var appData: AppData
    var body: some View {
        let current = self.appData.allResources.filter{$0.language.isDefault}.first!
        
        return VStack {
            HStack {
                Button("+") {
                    let newEntry = ResourceEntry(key: "", text: "", isNew: true)
                    
                    
                    var allResources = [LanguageResource]()
                    for s in self.appData.allResources {
                        var resources = s.resources.map{$0}
                        resources.append(newEntry)
                        allResources.append(LanguageResource(language: s.language, resources: resources, pathToResourceFile: s.pathToResourceFile))
                    }
                    self.appData.masterKeys.append(newEntry.key)
                    self.appData.allResources.removeAll()
                    self.appData.allResources = allResources
                    self.appData.masterKeys = self.appData.allResources.filter{$0.language.isDefault}.first!.resources.map{$0.key}
                    self.appData.baseResourceFile = self.baseFilePath
                }
                
                Spacer()
                Text("Resource Key")
                
                Spacer()
            }.padding(.top)
            
            ForEach(self.appData.masterKeys, id: \.self) { key in
                ResourceRow(currentItem: current.resources.filter{ $0.key == key }.first ?? ResourceEntry(key: "", text: "", isNew: true), originalKey: key, pathToResourceFile: self.baseFilePath, isPrimary: true, isKeys: true)
            }
        }
    }
}

struct ResourceColumn: View {
    @State var resourceSet: LanguageResource

    var language: Language
    
    var pathToResourceFile: String
    var body: some View {
        VStack {
            HStack {
                
                if self.language.isDefault {

                }
                
                Spacer()
                Text(self.language.name.uppercased())
                
                Spacer()
            }.padding(.top)

            ForEach(self.resourceSet.resources) { resource in
                ResourceRow(currentItem: resource, originalKey: resource.key, originalText: resource.text, pathToResourceFile: self.pathToResourceFile, isPrimary: self.language.isDefault)
            }
        }
        
    }
}

struct ResourceColumn_Previews: PreviewProvider {
    static var resourceSet = LanguageResource(language: Language("en-US", true), resources: [ResourceEntry(key: "key", text: "text")], pathToResourceFile: "")
    static var previews: some View {
        ResourceColumn(resourceSet: resourceSet, language: resourceSet.language, pathToResourceFile: "").environmentObject(AppData())
    }
}
