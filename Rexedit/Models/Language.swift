//
//  Language.swift
//  RexEdit
//
//  Created by Daniel McManus on 8/1/20.
//

import Foundation

struct Language: Identifiable {
    let id = UUID()
    var name: String
    var isDefault: Bool
    
    init(_ name: String, _ isDefault: Bool) {
        
        self.name = name
        self.isDefault = isDefault
    }
}
