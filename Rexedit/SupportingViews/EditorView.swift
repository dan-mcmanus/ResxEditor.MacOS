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
    @EnvironmentObject var appData: AppData
    
    var body: some View {
        HSplitView {
            KeysColumn(baseFilePath: self.appData.baseResourceFile)
            ForEach(self.appData.allResources, id: \.self.language.id) { resource in
                ResourceColumn(resourceSet: resource, language: resource.language, pathToResourceFile: resource.pathToResourceFile)
            }
        }.frame(maxHeight: .infinity, alignment: .top)
        
        
    }

    
    func createResxFile(destinationFile: String) {
        //https://docs.microsoft.com/en-us/dotnet/framework/tools/resgen-exe-resource-file-generator
        
        let folder = selectPath()
        let tempFile = "\(folder!)/temp.txt"
        FileUtil.createTextFile(path: folder!, name: "temp.txt", resources: []) // TODO
        Bash.execute(command: "resgen", arguments: [tempFile, "\(folder!)/\(destinationFile)"])
        FileUtil.deleteFile(tempFile)
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
    
    static var previews: some View {
        EditorView().environmentObject(AppData())
    }
}
