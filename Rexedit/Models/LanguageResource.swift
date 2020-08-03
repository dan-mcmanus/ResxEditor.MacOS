//
//  LanguageResource.swift
//  RexEdit
//
//  Created by Daniel McManus on 8/1/20.
//

import Foundation


struct LanguageResource: Identifiable {
    let id = UUID()
    var language: Language
    var resources: [ResourceEntry]
    var pathToResourceFile: String
    var masterKeys = [String]()
}
