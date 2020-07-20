//
//  ResourceEntryView.swift
//  Rexedit
//
//  Created by Daniel McManus on 7/18/20.
//

import SwiftUI

struct ResourceRow: View {
    @EnvironmentObject var fileData: FileData
    var fileUtil: FileUtility = FileUtility()
    
    @State private var invalid: Bool = false
    @State var currentItem: ResourceEntry
    @State var keyIsValid = false
    @State var textIsValid = false
    @State var isFocused = true
    var originalKey: String
    var originalText: String
    
    var body: some View {
        let linkColor = self.validateRow() ? Color.green : Color.gray
        return HStack {
            Spacer()
            
            TextField("Key",
                      text: self.$currentItem.key,
                      onEditingChanged: { _ in print("key changed") },
                      onCommit: {
                        validateKey(key: self.currentItem.key)
                      })
            Spacer()
            TextField("Value",
                      text: self.$currentItem.text,
                      onEditingChanged: { (onEditingChanged) in
                        print(onEditingChanged)
                      },
                      onCommit: {
                        validateText(text: self.currentItem.text)
                      })
            Spacer()
            
                Button("✓") {
                    if self.originalKey != self.currentItem.key {
                        fileUtil.updateEntry(filePath: self.fileData.filePath, originalKey: self.originalKey, originalText: self.originalText, updatedEntry: self.currentItem)
                    }
                    fileUtil.writeTo(filePath: self.fileData.filePath, entry: self.currentItem)
                    //self.fileData.resources.append(ResourceEntry(key: self.key, text: self.text))
                }.foregroundColor(linkColor)
                .disabled(!self.keyIsValid && !self.textIsValid)
            

            Spacer()
        }
        
        
    }
    
    func validateKey(key: String) {
        self.keyIsValid = key != ""
        
    }
    
    func validateText(text: String) {
        self.textIsValid = text != ""
    }
    
    func validateRow() -> Bool {
        return self.currentItem.key != "" && self.currentItem.text != ""
    }
    
}

//struct ResourceRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ResourceRow(resource: ResourceEntry(key: "", text: "e"))
//    }
//}
