//
//  AppData.swift
//  RexEdit
//
//  Created by Daniel McManus on 8/1/20.
//

import Foundation

class AppData: ObservableObject {
    @Published var baseResourceFile: String = ""
    @Published var defaultNameSpace = ""
    @Published var defaultClassName = ""
    @Published var allResources: [LanguageResource] = [LanguageResource(
        language: Language("en-US", true),
        resources: [ResourceEntry(key: "key", text: "value")],
        pathToResourceFile: ""
    )]
    @Published var supportedLanguages: [Language] = []
    @Published var filesWithLanguage: [LanguageResource] = []
    @Published var filePath = ""
    @Published var selectedLanguageResource: LanguageResource = LanguageResource(
        language: Language("en-US", true),
        resources: [],
        pathToResourceFile: ""
    )
}
