//
//  NavBar.swift
//  RexEdit
//
//  Created by Daniel McManus on 7/25/20.
//

import SwiftUI

struct NavBar: View {
    @EnvironmentObject var appData: AppData
    @EnvironmentObject var fileData: FileData
    @State var isHidden = false
    @State var defaultLanguage = Language("en-US", "English (US) [Default]", true)
    var body: some View {
        return ZStack {
            if !isHidden {
                Button("Load File") {
                    self.selectFile()
                }
            } else {
                NavigationView {
                    List(appData.filesWithLanguage) {lang in
                        NavigationLink(lang.language.name, destination: EditorView(forLanguage: lang.language.id))
                    }.frame(minWidth: 100, maxWidth: 400)
                    

                }
            }

        }

    }
    
    // https://ourcodeworld.com/articles/read/1117/how-to-implement-a-file-and-directory-picker-in-macos-using-swift-5
    func selectFile() {
        let dialog = NSOpenPanel()
        
        dialog.title = "Choose a file"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.allowsMultipleSelection = true
        dialog.canChooseDirectories = false
        
        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let results = dialog.urls
            for result in results {
                let segs = result.lastPathComponent.components(separatedBy: ".")
                if segs.count > 2 {
                    appData.filesWithLanguage.append(LanguageResource(language: Language(segs[1], segs[1], false), resources: FileUtility.parseFile(filePath: result.path), pathToResourceFile: result.path ))
                    
                }
                if segs.count == 2 {
                    
                    ResXFileCodeGenerator.generateDesignerFile(resxFile: result.path, nameSpace: "MemberMobile.Api", className: "Translations", designerFileName: "Translations1.designer.cs")
                    
                    appData.filesWithLanguage.append(LanguageResource(language: Language(defaultLanguage.id, defaultLanguage.name, true), resources: FileUtility.parseFile(filePath: result.path), pathToResourceFile: result.path))
                }
            }
            appData.filesWithLanguage = appData.filesWithLanguage.sorted{ $0.language.isDefault && !$1.language.isDefault }
            isHidden = true
        } else {
            // User clicked on "Cancel"
            return
        }
    }
}

struct NavBar_Previews: PreviewProvider {
    static var previews: some View {
        NavBar().environmentObject(FileData()).environmentObject(AppData())
    }
}
