//
//  EditorView.swift
//  Rexedit
//
//  Created by Daniel McManus on 7/18/20.
//

import SwiftUI
import Foundation
import ShellOut


struct EditorView: View {
    @State var forLanguage: String
    @EnvironmentObject var fileData: FileData
    @EnvironmentObject var appData: AppData
    @State var match: LanguageResource?

    
    func addResourceNode() {
        fileData.resources.insert(ResourceEntry(key: "", text: "", isNew: true), at: 0)
    }
    
    
    
    var body: some View {
        ScrollView {
            VStack {
                Button("New Resource File") {
                    createResxFile(destinationFile: "Resources.resx")
                }.padding()
                HStack {
                    Button("+") {
                        addResourceNode()
                    }.padding(.leading)
                    Spacer()
                    Text("Resource Key")
                    Spacer()
                    Text("Resource Value")
                    Spacer()
                    
                    
                }.padding(.top)
                ForEach(getMatch().resources, id: \.self.key) { item in
                    ResourceRow(currentItem: item, originalKey: item.key, originalText: item.text)
                }
                
                Spacer()
            }
        }.frame(minWidth: 400, maxHeight: .infinity)
    }
    
    
    func getMatch() -> LanguageResource {
        let match = appData.filesWithLanguage.first(where: { $0.language.id == forLanguage})!
        return match
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
                
                fileData.resources = FileUtility.parseFile(filePath: fileData.filePath)
                fileData.resources = fileData.resources.sorted(by: { $0.key.lowercased() < $1.key.lowercased() })
            }
            
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    
    func createResxFile(destinationFile: String) {
        //https://docs.microsoft.com/en-us/dotnet/framework/tools/resgen-exe-resource-file-generator
        
        let folder = selectPath()
        let tempFile = "\(folder!)/temp.txt"
        FileUtility.createTextFile(path: folder!, name: "temp.txt", resources: fileData.resourcesToAdd)
        Bash.execute(command: "resgen", arguments: [tempFile, "\(folder!)/\(destinationFile)"])
        FileUtility.deleteFile(tempFile)
    }
    
    func selectPath() -> String? {
        let dialog = NSOpenPanel()
        dialog.title = "Choose a directory"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.allowsMultipleSelection = false
        dialog.canChooseDirectories = true
        dialog.canChooseFiles = false
        
        if dialog.runModal() == NSApplication.ModalResponse.OK {
            let result = dialog.url
            return result!.path
        } else {
            return nil
        }
        
    }
}


struct EditorView_Previews: PreviewProvider {
    @State static var language = "en-US"
    static var previews: some View {
        EditorView(forLanguage: language).environmentObject(FileData()).environmentObject(AppData())
    }
}
