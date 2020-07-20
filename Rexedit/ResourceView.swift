//
//  ResourceView.swift
//  Rexedit
//
//  Created by Daniel McManus on 7/18/20.
//

import SwiftUI
import Foundation


struct ResourceView: View {
    @EnvironmentObject var fileData: FileData
    var fileUtil: FileUtility = FileUtility()
    
    
    func addResourceNode() {
        fileData.resources.append(ResourceEntry(key: "", text: ""))
    }
    
    var body: some View {
        
        return VStack {
            HStack {
                Button("+") {
                    addResourceNode()
                }
                .padding(.leading)
                Spacer()
                Text("Resource Key")
                Spacer()
                Text("Resource Value")
                Spacer()

                Button("Choose file") {
                    selectFile()
                    
                }.padding(.trailing)
            }.padding(.top)
            ForEach(self.fileData.resources) { resource in
                ResourceRow(currentItem: resource, originalKey: resource.key, originalText: resource.text)
                
            }.textFieldStyle(RoundedBorderTextFieldStyle())
        
            Spacer()
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // https://ourcodeworld.com/articles/read/1117/how-to-implement-a-file-and-directory-picker-in-macos-using-swift-5
    func selectFile() {
        let dialog = NSOpenPanel()
        
        dialog.title = "Choose a file"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.allowsMultipleSelection = false
        dialog.canChooseDirectories = false
        
        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url
            
            if (result != nil) {
                self.fileData.filePath = result!.path
                self.fileData.resourceDictionary = fileUtil.parseFile(filePath: self.fileData.filePath)
                self.fileData.resources.removeAll()
                for (key, val) in self.fileData.resourceDictionary {
                    self.fileData.resources.append(ResourceEntry(key: key, text: val))
                }
            }
            
        } else {
            // User clicked on "Cancel"
            return
        }
    }
}

struct ResourceView_Previews: PreviewProvider {
    static var previews: some View {
        ResourceView().environmentObject(FileData())
            
    }
}
