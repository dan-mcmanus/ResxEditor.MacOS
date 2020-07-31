//
//  FileData.swift
//  RexEdit
//
//  Created by Daniel McManus on 7/19/20.
//

import SwiftUI
import Combine

final class FileData: ObservableObject {
    @Published var resourceDictionary: [String: String] = ["": ""]
    @Published var resources: [ResourceEntry] = [ResourceEntry(key: "", text: "", isNew: true)]
    @Published var resourcesToAdd: [ResourceEntry] = []
    @Published var filePath = ""
}

class AppData: ObservableObject {
    //@Published var supportedLanguages: [Language] = [Language("en-US", "English (US)"), Language("es","Spanish (Neutral)")]
    @Published var supportedLanguages: [Language] = []
    @Published var filesWithLanguage: [LanguageResource] = []
    @Published var filePath = ""
    @Published var selectedLanguageResource: LanguageResource = LanguageResource(
        language: Language("en-US", "English (US)", true),
        resources: [],
        pathToResourceFile: ""
    )
}

