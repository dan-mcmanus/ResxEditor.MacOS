//
//  FileData.swift
//  Rexedit
//
//  Created by Daniel McManus on 7/19/20.
//

import SwiftUI
import Combine

final class FileData: ObservableObject {
    @Published var resourceDictionary: [String: String] = ["": ""]
    @Published var resources: [ResourceEntry] = [ResourceEntry()]
    @Published var resourcesToAdd: [ResourceEntry] = []
    @Published var originalEntries: [ResourceEntry] = []
    @Published var filePath = ""
}
