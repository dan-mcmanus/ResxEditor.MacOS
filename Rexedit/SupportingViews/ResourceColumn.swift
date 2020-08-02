//
//  ResourceColumn.swift
//  RexEdit
//
//  Created by Daniel McManus on 8/2/20.
//

import SwiftUI


struct ResourceColumn: View {
    @State var resourceSet: LanguageResource
    var language: Language
    
    var pathToResourceFile: String
    
    var body: some View {
        VStack {
            HStack {
                
                if self.language.isDefault {
                    Button("+") {
                        
                    }.padding(.leading)
                    Spacer()
                    Text("Resource Key")
                }
                
                Spacer()
                Text(self.language.name)
                
                Spacer()
            }.padding(.top)
                ForEach(self.resourceSet.resources) { resource in
                    ResourceRow(currentItem: resource, originalKey: resource.key, originalText: resource.text, pathToResourceFile: self.pathToResourceFile, isPrimary: self.language.isDefault)
                }
            Spacer()
        }.clipped()
        
    }
}

struct ResourceColumn_Previews: PreviewProvider {
    static var resourceSet = LanguageResource(language: Language("en-US", true), resources: [ResourceEntry(key: "key", text: "text")], pathToResourceFile: "")
    static var previews: some View {
        ResourceColumn(resourceSet: resourceSet, language: resourceSet.language, pathToResourceFile: "").environmentObject(AppData())
    }
}
