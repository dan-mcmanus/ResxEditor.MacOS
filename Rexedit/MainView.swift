//
//  MainView.swift
//  RexEdit
//
//  Created by Daniel McManus on 7/25/20.
//

import SwiftUI
import AppKit
import Combine

struct MainView: View {
    @EnvironmentObject var appData: AppData
    @State var isHidden = false
    @State var hasUpdates = false
    @State var headerHeight: CGFloat = 40.0
    
    let pub = NotificationCenter.default
            .publisher(for: NSNotification.Name("hasupdates"))
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                Image(nsImage: NSImage(named: NSImage.refreshTemplateName)!)
                    .onTapGesture {
                        self.refresh()
                        self.hasUpdates = false
                        self.headerHeight = 40
                    }.onReceive(pub) { (output) in
                        self.hasUpdates = true
                        self.headerHeight = 60
                    }
                
                .padding()
                    if self.hasUpdates {
                        Text("refresh to view updates")
                            .padding(.leading)
                        
                    }
                }
                Spacer()
            }.frame(maxWidth: .infinity, maxHeight: self.headerHeight)
            ScrollView([.vertical, .horizontal]) {
                if !isHidden {
                    Button("Load File") {
                        self.selectFile()
                    }
                } else {
                    
                    EditorView().padding()
                    
                }
            }.frame(minWidth: 500, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity).background(Color(0x343A40)).padding([.horizontal, .bottom])
        }
    }
    
    
    func refresh() {
        let result = self.appData.baseResourceFile 
        self.appData.allResources = FileUtil.parseFiles(filePath: result).sorted{ $0.language.isDefault && !$1.language.isDefault }
        self.appData.allResources = self.appData.allResources.sorted{ $0.language.isDefault && !$1.language.isDefault }
        self.appData.baseResourceFile = result
        self.appData.allResources = self.appData.allResources.sorted{ $0.language.isDefault && !$1.language.isDefault }
        
        self.appData.masterKeys = self.appData.allResources.filter{ $0.language.isDefault }.first!.resources.map{ $0.key }.sorted(by: {$0.lowercased() < $1.lowercased()})
    }
    
    // https://ourcodeworld.com/articles/read/1117/how-to-implement-a-file-and-directory-picker-in-macos-using-swift-5
    func selectFile() {
        let dialog = NSOpenPanel()
        dialog.title = "Choose a file"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.allowsMultipleSelection = true
        dialog.canChooseDirectories = false
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url!
            self.appData.allResources = FileUtil.parseFiles(filePath: result.path)
            self.appData.allResources = self.appData.allResources.sorted{ $0.language.isDefault && !$1.language.isDefault }
            self.appData.baseResourceFile = result.path

            self.appData.allResources = self.appData.allResources.sorted{ $0.language.isDefault && !$1.language.isDefault }
            self.appData.masterKeys = self.appData.allResources.filter{ $0.language.isDefault }.first!.resources.map{ $0.key }
            self.isHidden = true
        } else {
            // User clicked on "Cancel"
            return
        }
//        let result = "/Users/dmcmanus/source/MemberMobileApp/MemberMobile.Api/Resources/Translations.resx"

    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(AppData())
            //.environmentObject(FileData())
    }
}
