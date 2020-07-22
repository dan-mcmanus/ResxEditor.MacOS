//
//  RexeditApp.swift
//  Rexedit
//
//  Created by Daniel McManus on 7/18/20.
//

import SwiftUI

@main
struct RexEditApp: App {
    var body: some Scene {
        WindowGroup {
            ResourceView()
                .environmentObject(FileData())
                .environmentObject(Entry())
        }
    }
}
