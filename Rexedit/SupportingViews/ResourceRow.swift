//
//  ResourceEntryView.swift
//  Rexedit
//
//  Created by Daniel McManus on 7/18/20.
//

import SwiftUI


struct ResourceRow: View {
    //@EnvironmentObject var fileData: FileData
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
    var isKeys = false
    
    var body: some View {
        HStack {
            Spacer()
            Button(isLocked ? "edit" : "save") {
                self.isLocked = !self.isLocked
                if self.isLocked {
                    //self.save(entry: self.currentItem)
                    if self.currentItem.isNew {
                        for file in self.appData.allResources {
                            FileUtil.writeTo(filePath: file.pathToResourceFile, entry: ResourceEntry(key: self.currentItem.key, text: " "))
                        }
                    }
                    
                    if self.currentItem.key != self.originalKey {
                        for file in self.appData.allResources {
                            saveKey(filePath: file.pathToResourceFile, entry: self.currentItem)
                        }
                        
                        self.runCodeGen()
                        self.isLocked = true
                    }
                    
                    if self.currentItem.text != self.originalText {
                        saveText(entry: self.currentItem)
                    }
                    
                    self.appData.allResources = FileUtil.parseFiles(filePath: self.appData.baseResourceFile)
                }
            }
            Spacer()
            
            if self.isKeys {
                TextField("Key",
                          text: $currentItem.key,
                          onEditingChanged: { (onEditingChanged) in
                            if !onEditingChanged {
                                if self.currentItem.key.isEmpty {
                                    self.keyIsValid = false
                                }
                            }
                          },
                          onCommit: {
                            
                            if self.currentItem.key.contains(" ") {
                                self.currentItem.key = self.currentItem.key.trimmingCharacters(in: .whitespacesAndNewlines)
                            }
                          }).frame(minWidth: 100).disabled(isLocked).border(keyIsValid ? Color.clear : Color.red.opacity(0.5))
                Spacer()
            } else {
                TextField("Value",
                          text: $currentItem.text,
                          onCommit: {
                            self.validateText(text: self.currentItem.text)
                          }).disabled(isLocked)
                    .frame(minWidth: 400)
            }

            Spacer()

        }
        
        
    }
    
    func saveKey(filePath: String, entry: ResourceEntry) {
        if self.originalKey != entry.key {
            FileUtil.updateKey(filePath: filePath, originalKey: self.originalKey, updatedEntry: entry)
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
                
                ResXFileCodeGenerator.generateDesignerFile(resxFile: self.appData.baseResourceFile, nameSpace: self.appData.defaultNameSpace, className: self.appData.defaultClassName, designerFileName: FileUtil.getFileNameFromPath(fullyQualifiedPathString: self.appData.baseResourceFile).replacingOccurrences(of: "resx", with: "Designer.cs"))
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
