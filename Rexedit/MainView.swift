//
//  MainView.swift
//  RexEdit
//
//  Created by Daniel McManus on 7/25/20.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var appData: AppData
    @EnvironmentObject var fileData: FileData
    var body: some View {
        VStack {
            HSplitView {
                NavBar()
            }.frame(minWidth: 300, minHeight: 100, maxHeight: .infinity, alignment: .leading)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(AppData())
            .environmentObject(FileData())
    }
}
