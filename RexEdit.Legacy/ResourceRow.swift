//
//  ResourceEntryView.swift
//  RexEdit
//
//  Created by Daniel McManus on 7/18/20.
//

import SwiftUI

struct ResourceRow: View {
    @EnvironmentObject var fileData: FileData

    @State var currentItem: ResourceEntry
    @State var keyIsValid = true
    @State var textIsValid = false
    @State var isLocked = true

    var originalKey: String
    var originalText: String

    var body: some View {
        HStack {
            Spacer()
            Button(isLocked ? "edit" : "save") {
                self.isLocked = !self.isLocked
                if self.isLocked {
                    self.fileData.resourcesToAdd.append(ResourceEntry(key: self.currentItem.key, text: self.currentItem.text, isNew: true))
                    if self.originalKey != self.currentItem.key || self.originalText != self.currentItem.text {
                        if self.currentItem.isNew {
                            FileUtility.writeTo(filePath: self.fileData.filePath, entry: self.currentItem)
                        } else {
                            FileUtility.updateEntry(filePath: self.fileData.filePath, originalKey: self.originalKey,
                                    originalText: self.originalText, updatedEntry: self.currentItem)
                        }
                        self.isLocked = true
                    }
                }
            }
            Spacer()

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
                    }).disabled(isLocked)
                    .border(keyIsValid ? Color.clear : Color.red.opacity(0.5))
                    .focusable(true)
            Spacer()
            TextField("Value",
                    text: $currentItem.text,
                    onCommit: {
                        self.validateText(text: self.currentItem.text)
                    }).disabled(isLocked)

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
