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
    var originalText: String
    var pathToResourceFile: String
    var isPrimary: Bool
    
    var body: some View {
        HStack {
            Spacer()
            Button(isLocked ? "edit" : "save") {
                self.isLocked = !self.isLocked
                if self.isLocked {
                    //self.save(entry: self.currentItem)
                    if self.currentItem.isNew {
                        FileUtil.addEntry(toFile: self.pathToResourceFile, newEntry: ResourceEntry(key: self.currentItem.key, text: self.currentItem.text))
                    }
                }
            }
            Spacer()
            
            if self.isPrimary {
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
                          }).frame(maxWidth: .infinity).disabled(isLocked).border(keyIsValid ? Color.clear : Color.red.opacity(0.5))
                Spacer()
            }

            ForEach(self.appData.filesWithLanguage, id: \.self.language.id) { lang in
                VStack {
                TextField("Value",
                          text: $currentItem.text,
                          onCommit: {
                            self.validateText(text: self.currentItem.text)
                          }).disabled(isLocked)
                }
            }

            Spacer()

        }
        
        
    }
    
    func save(entry: ResourceEntry) {
        if self.originalKey != self.currentItem.key || self.originalText != self.currentItem.text {
            if currentItem.isNew {
                FileUtil.writeTo(filePath: self.pathToResourceFile, entry: self.currentItem)
            } else {
                FileUtil.updateEntry(filePath: self.pathToResourceFile, originalKey: self.originalKey,
                                        originalText: self.originalText, updatedEntry: self.currentItem)
            }
            if self.appData.selectedLanguageResource.language.isDefault {
                self.appData.defaultNameSpace = ResXFileCodeGenerator.getNamespace(designerFile: self.appData.baseResourceFile)
                self.appData.defaultClassName = ResXFileCodeGenerator.getClassName(designerFile: self.appData.baseResourceFile)
                
                ResXFileCodeGenerator.generateDesignerFile(resxFile: self.appData.baseResourceFile, nameSpace: self.appData.defaultNameSpace, className: self.appData.defaultClassName, designerFileName: FileUtil.getFileNameFromPath(fullyQualifiedPathString: self.appData.baseResourceFile).replacingOccurrences(of: "resx", with: "Designer.cs"))
            }

            self.isLocked = true
        }
    }
    
    func update(isKey: Bool) {
        if isKey {
            FileUtil.updateKey(filePath: self.pathToResourceFile, originalKey: self.originalKey, updatedEntry: self.currentItem)
        } else {
            FileUtil.updateEntry(filePath: self.pathToResourceFile, originalKey: self.originalKey,
                                 originalText: self.originalText, updatedEntry: self.currentItem)
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

//struct ResourceRow_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            ResourceRow(fileData: ResourceEntry(key: "", text: "", isNew: true), appData: "", currentItem: "", keyIsValid: "", ).environmentObject(AppData())
//        }
//    }
//}

struct ResourceRow_Previews: PreviewProvider {
    static var previews: some View {
        ResourceRow(currentItem: ResourceEntry(key: "a", text: "a"), originalKey: "og", originalText: "og", pathToResourceFile: "", isPrimary: true).environmentObject(AppData())
    }
}
