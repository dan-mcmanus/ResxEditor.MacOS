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
    
    func addResourceNode() {
        fileData.resources.append(ResourceEntry(key: "", text: "", isNew: true))
    }
    
    var body: some View {
        
        return
            ScrollView {
                VStack {
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
                    ForEach(fileData.resources) { resource in
                        ResourceRow(currentItem: resource, originalKey: resource.key, originalText: resource.text)
                        
                    }.textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Spacer()
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
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
                fileData.filePath = result!.path
                fileData.resources.removeAll()
                
                fileData.resources = parseFile(filePath: fileData.filePath)
                fileData.resources = fileData.resources.sorted(by: { $0.key.lowercased() < $1.key.lowercased() })
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
