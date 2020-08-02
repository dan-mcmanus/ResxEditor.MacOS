//
//  MainView.swift
//  RexEdit
//
//  Created by Daniel McManus on 7/25/20.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var appData: AppData
    //@EnvironmentObject var fileData: FileData
    @State var isHidden = false
    var body: some View {
        
        ScrollView([.vertical, .horizontal]) {
            if !isHidden {
                Button("Load File") {
                    self.selectFile()
                }
            } else {
                
                EditorView().padding()
                
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color(0x343A40))
        .edgesIgnoringSafeArea(.all)
        
    }
    
    // https://ourcodeworld.com/articles/read/1117/how-to-implement-a-file-and-directory-picker-in-macos-using-swift-5
    func selectFile() {
        let dialog = NSOpenPanel()
        
        dialog.title = "Choose a file"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.allowsMultipleSelection = true
        dialog.canChooseDirectories = false
        var filesWithLanguage: [LanguageResource] = []
        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let results = dialog.urls
            for result in results {
                self.appData.allResources = FileUtil.parseFiles(filePath: result.path)
                self.appData.allResources = self.appData.allResources.sorted{ $0.language.isDefault && !$1.language.isDefault }
                
                let segs = result.lastPathComponent.components(separatedBy: ".")
                if segs.count > 2 {
                    filesWithLanguage.append(LanguageResource(language: Language(segs[1], false),
                                                              resources: FileUtil.parseFile(filePath: result.path),
                                                              pathToResourceFile: result.path))
                    
                }
                if segs.count == 2 {
                    self.appData.baseResourceFile = result.path
                    filesWithLanguage.append(LanguageResource(language: Language("en-US", true), resources: FileUtil.parseFile(filePath: result.path), pathToResourceFile: result.path))
                }
            }
            self.appData.filesWithLanguage = filesWithLanguage.sorted{ $0.language.isDefault && !$1.language.isDefault }
            self.isHidden = true
        } else {
            // User clicked on "Cancel"
            return
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(AppData())
            //.environmentObject(FileData())
    }
}
