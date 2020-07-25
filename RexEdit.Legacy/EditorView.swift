//
//  ContentView.swift
//  RexEdit.Legacy
//
//  Created by Daniel McManus on 7/23/20.
//
import SwiftUI
import Foundation
import ShellOut

struct EditorView: View {
    @EnvironmentObject var fileData: FileData

    func addResourceNode() {
        fileData.resources.append(ResourceEntry(key: "", text: "", isNew: true))
    }

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Button("+") {
                        self.addResourceNode()
                    }.padding(.leading)
                    Spacer()
                    Button("New Resource File") {
                        self.createResxFile(destinationFile: "Resources.resx")
                    }.padding()
                    Spacer()
                    Button("Load file") {
                        self.selectFile()

                    }.padding(.trailing)
                }
                HStack {

                    Spacer()
                    Text("Resource Key")
                    Spacer()
                    Text("Resource Value")
                    Spacer()


                }.padding(.top)
                ForEach(fileData.resources, id: \.self.key) { resource in
                    ResourceRow(currentItem: resource, originalKey: resource.key, originalText: resource.text)
                            .focusable(true)
                }
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EditorView().environmentObject(FileData())
    }
}
