//
//  ResourceEntryView.swift
//  Rexedit
//
//  Created by Daniel McManus on 7/18/20.
//

import SwiftUI

struct ResourceRow: View {
    @EnvironmentObject var fileData: FileData
    @EnvironmentObject var entry: Entry
    
    @State var currentItem: ResourceEntry
    @State var keyIsValid = true
    @State var textIsValid = false
    @State var isLocked = true
    
    var originalKey: String
    var originalText: String
    
    var body: some View {
        return HStack {
            Spacer()
            Button("") {
                isLocked = !isLocked
                
                if isLocked {
                    fileData.resourcesToAdd.append(ResourceEntry(key: currentItem.key, text: currentItem.text, isNew: true))
                }
            }.overlay(isLocked ? Image(systemName: "lock") : Image(systemName: "lock.open"))
            Spacer()
            
            TextField("Key",
                      text: $currentItem.key,
                      onEditingChanged: { (onEditingChanged) in
                        if !onEditingChanged {
                            if currentItem.key.isEmpty {
                                keyIsValid = false
                            }
                        }
                      },
                      onCommit: {

                        if currentItem.key.contains(" ") {
                            currentItem.key = currentItem.key.trimmingCharacters(in: .whitespacesAndNewlines)
                        }
                      }).disabled(isLocked).border(keyIsValid ? Color.clear : Color.red.opacity(0.5))
            Spacer()
            TextField("Value",
                      text: $currentItem.text,
                      onCommit: {
                        validateText(text: currentItem.text)
                      }).disabled(isLocked)
            Spacer()

            
            
            Button("save") {
                if originalKey != currentItem.key || originalText != currentItem.text {
                    if currentItem.isNew {
                        FileUtility.writeTo(filePath: fileData.filePath, entry: currentItem)
                    } else {
                        FileUtility.updateEntry(filePath: fileData.filePath, originalKey: originalKey,
                                                originalText: originalText, updatedEntry: currentItem)
                    }
                }
                
            }.disabled(isLocked)
            Spacer()
        }
        
        
    }
    
    func validateKey(key: String) {
        keyIsValid = key != ""
        
    }
    
    func validateText(text: String) {
        textIsValid = text != ""
    }
    
    func validateRow() -> Bool {
        return currentItem.key != "" && currentItem.text != ""
    }
    
}

struct ResourceRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ResourceRow(currentItem: ResourceEntry(key: "", text: "", isNew: true), originalKey: "", originalText: "")
            ResourceRow(currentItem: ResourceEntry(key: "", text: "", isNew: true), originalKey: "", originalText: "")
        }
    }
}
