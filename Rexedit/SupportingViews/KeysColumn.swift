//
//  KeysColumn.swift
//  RexEdit
//
//  Created by Daniel McManus on 8/8/20.
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
                ResourceRow(currentItem: current.resources.filter{ $0.key == key }.first ?? ResourceEntry(key: "", text: "", isNew: true), originalKey: key, pathToResourceFile: self.baseFilePath, isPrimary: true, isKeysColumn: true)
            }
        }
    }
}

struct KeysColumn_Previews: PreviewProvider {
    static var previews: some View {
        KeysColumn(baseFilePath: "").environmentObject(AppData())
    }
}
