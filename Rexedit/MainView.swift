//
//  MainView.swift
//  RexEdit
//
//  Created by Daniel McManus on 7/25/20.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
            HSplitView {
                NavBar()
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(AppData())
            .environmentObject(FileData())
    }
}
