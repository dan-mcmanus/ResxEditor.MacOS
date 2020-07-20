//
//  ResourceNode.swift
//  Rexedit
//
//  Created by Daniel McManus on 7/18/20.
//

import Foundation
import SwiftUI

struct ResourceEntry: Identifiable {
    let id = UUID()
    var key = ""
    var text = ""
  
}
extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        guard let index = firstIndex(of: object) else {return}
        remove(at: index)
    }
    
}
