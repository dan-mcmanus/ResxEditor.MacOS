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
    
    @Published var masterKeys = [String]()
//    @Published var supportedLanguages: [Language] = []
//    @Published var filesWithLanguage: [LanguageResource] = []
    @Published var filePath = ""
    @Published var selectedLanguageResource: LanguageResource = LanguageResource(
        language: Language("en-US", true),
        resources: [],
        pathToResourceFile: ""
    )
    @Published var files = [String]()
    
    func clear() {
        self.allResources = [LanguageResource(
            language: Language("en-US", true),
            resources: [ResourceEntry(key: "key", text: "value")],
            pathToResourceFile: ""
        )]
        self.baseResourceFile = ""
        self.defaultNameSpace = ""
        self.defaultClassName = ""
        self.masterKeys = [String]()
        self.filePath = ""
        self.selectedLanguageResource = LanguageResource(
            language: Language("en-US", true),
            resources: [],
            pathToResourceFile: ""
        )
        self.files = [String]()
    }
}
