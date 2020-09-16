//
//  ResourceColumn.swift
//  RexEdit
//
//  Created by Daniel McManus on 8/2/20.
//

import SwiftUI

struct ResourceColumn: View {
    @EnvironmentObject var appData: AppData
    @State var resourceSet: LanguageResource
    var codeGenTypes = CodeGenType.allCases.map {$0.rawValue}
    @State private var selectedCodeGenIdx = 0
    @State var isShowing = false
    @State var className = ""
    @State var ns = ""
    var language: Language
    
    var pathToResourceFile: String
    var body: some View {
        VStack {
            HStack {
                
                Spacer()
                Text(self.language.name.uppercased())
                Spacer()
                if self.language.isDefault {
                    Text("Code Gen")
                    Picker(selection: $selectedCodeGenIdx, label: Text("")) {
                        ForEach(0 ..< codeGenTypes.count) {
                            Text(self.codeGenTypes[$0])
                        }
                    }
                    .onReceive([self.codeGenTypes[self.selectedCodeGenIdx]].publisher.first()) { value in
                        self.setCodeGenType(value: value)
                    }
                    .frame(width: 100)
                    
                }

                
                
                Spacer()
            }.padding(.top)

            ForEach(self.resourceSet.resources) { resource in
                ResourceRow(currentItem: resource, originalKey: resource.key, originalText: resource.text, pathToResourceFile: self.pathToResourceFile, isPrimary: self.language.isDefault)
            }
        }
        
    }
    
    func setCodeGenType(value: String) {
        let cgType = CodeGenType.init(rawValue: value)!
        if self.appData.codeGenType != cgType {
            self.appData.codeGenType = cgType
            if self.appData.codeGenType != CodeGenType.none {
                    
                    self.appData.defaultNameSpace = ResXFileCodeGenerator.getNamespace(designerFile: self.appData.baseResourceFile)
                    self.appData.defaultClassName = ResXFileCodeGenerator.getClassName(designerFile: self.appData.baseResourceFile)
                    
                    ResXFileCodeGenerator.generateDesignerFile(resxFile: self.appData.baseResourceFile,
                                                               nameSpace: self.appData.defaultNameSpace,
                                                               className: self.appData.defaultClassName,
                                                               designerFileName: FileUtil.getFileNameFromPath(fullyQualifiedPathString: self.appData.baseResourceFile).replacingOccurrences(of: "resx", with: "Designer.cs"),
                                                               modifier: self.appData.codeGenType.rawValue)
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
