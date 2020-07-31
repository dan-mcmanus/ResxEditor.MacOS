//
//  ResourceNode.swift
//  Rexedit
//
//  Created by Daniel McManus on 7/18/20.
//

import Foundation
import SwiftUI

struct ResourceEntry {
    var key = ""
    var text = ""
    var isNew: Bool
    
    init(key: String, text: String, isNew: Bool) {
        self.key = key
        self.text = text
        self.isNew = isNew
    }
  
}
struct Language: Identifiable {
    var id: String
    var name: String
    var isDefault = false

    init(_ id: String, _ name: String, _ isDefault: Bool) {
        self.id = id
        self.name = name
        self.isDefault = isDefault
    }
}

struct LanguageResource: Identifiable {
    let id = UUID()
    var language: Language
    var resources: [ResourceEntry]
    var pathToResourceFile: String
}
