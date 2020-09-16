//
//  ResourceEntryView.swift
//  Rexedit
//
//  Created by Daniel McManus on 7/18/20.
//

import SwiftUI


struct ResourceRow: View {
    @EnvironmentObject var appData: AppData
    @State var currentItem: ResourceEntry
    @State var keyIsValid = true
    @State var textIsValid = false
    @State var isLocked = true
    @State var keyChanged = false
    
    var originalKey: String
    var originalText: String = ""
    var pathToResourceFile: String
    var isPrimary: Bool
    var isKeysColumn = false
    
    var body: some View {
        HStack {
            
            Spacer()
            
            if self.isKeysColumn {
                TextField("Key",
                          text: $currentItem.key,
                          onCommit: {
                            if self.currentItem.key != self.originalKey {
                                if self.currentItem.key.contains(" ") {
                                    self.currentItem.key = self.currentItem.key.trimmingCharacters(in: .whitespacesAndNewlines)
                                }
                                if self.currentItem.isNew {
                                    for file in self.appData.allResources {
                                        FileUtil.writeTo(filePath: file.pathToResourceFile, entry: ResourceEntry(key: self.currentItem.key, text: " "))
                                    }
                                } else {
                                    for file in self.appData.files {
                                        FileUtil.updateKeyIn(file: file, originalKey: self.originalKey, updatedKey: self.currentItem.key)
                                    }
                                }
                            }
                            
                          }).frame(minWidth: 100).border(keyIsValid ? Color.clear : Color.red.opacity(0.5))
                Spacer()
            } else {
                TextField("Value",
                          text: $currentItem.text,
                          onCommit: {
                            if self.currentItem.text != self.originalText {
                                self.saveText(entry: self.currentItem)
                            }

                          })
                    .frame(minWidth: 400)
            }

            Spacer()

        }
        
        
    }
    
    func saveText(entry: ResourceEntry) {
        FileUtil.updateText(filePath: self.pathToResourceFile, entry: entry)
        
        self.runCodeGen()
        self.isLocked = true
    }
    
    func runCodeGen() {
        if self.appData.selectedLanguageResource.language.isDefault {
            if ResXFileCodeGenerator.checkForDesignerFile(filePath: self.pathToResourceFile) {
         
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
    
    func validateKey(key: String) {
        keyIsValid = key != ""
        
    }
    
    func validateText(text: String) {
        textIsValid = text != ""
    }
    
    func validateRow() -> Bool {
        return self.currentItem.key != "" && self.currentItem.text != ""
    }
    
}

struct ResourceRow_Previews: PreviewProvider {
    static var previews: some View {
        ResourceRow(currentItem: ResourceEntry(key: "a", text: "a"), originalKey: "og", originalText: "og", pathToResourceFile: "", isPrimary: true).environmentObject(AppData())
    }
}
