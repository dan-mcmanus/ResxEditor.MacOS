//
//  FileData.swift
//  Rexedit
//
//  Created by Daniel McManus on 7/19/20.
//

import SwiftUI
import Combine

final class FileData: ObservableObject {
    @Published var resources: [ResourceEntry] = [ResourceEntry(key: "", text: "", isNew: true)]
    @Published var resourcesToAdd: [ResourceEntry] = []
    @Published var originalEntries: [ResourceEntry] = []
    @Published var filePath = ""
    //@Published var folderPath = ""
}
