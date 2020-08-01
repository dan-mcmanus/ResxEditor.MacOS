//
//  ResourceNode.swift
//  RexEdit
//
//  Created by Daniel McManus on 7/18/20.
//

import Foundation
import SwiftUI

struct ResourceEntry: Identifiable {
    let id = UUID()
    var key = ""
    var text = ""
    var isNew: Bool
    
    init(key: String, text: String, isNew: Bool) {
        self.key = key
        self.text = text
        self.isNew = isNew
    }
  
}


