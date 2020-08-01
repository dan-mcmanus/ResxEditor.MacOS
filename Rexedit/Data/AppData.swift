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
    
    @Published var supportedLanguages: [Language] = []
    @Published var filesWithLanguage: [LanguageResource] = []
    @Published var filePath = ""
    @Published var selectedLanguageResource: LanguageResource = LanguageResource(
        language: Language("en-US", "English (US)", true),
        resources: [],
        pathToResourceFile: ""
    )
}
