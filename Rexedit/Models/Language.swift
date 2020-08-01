//
//  Language.swift
//  RexEdit
//
//  Created by Daniel McManus on 8/1/20.
//

import Foundation

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
