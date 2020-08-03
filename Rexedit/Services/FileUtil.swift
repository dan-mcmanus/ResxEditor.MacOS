//
//  ResourceParser.swift
//  Rexedit
//
//  Created by Daniel McManus on 7/19/20.
//

import Foundation
import AEXML
import SwiftUI
import Files


class FileUtil {
    static var hasUpdates = false
    
    static func getDirectoryOf(file: String) -> String {
        var pathSegments = file.split(separator: "/")
        pathSegments.removeLast()
        let path = pathSegments.joined(separator: "/")
        return path.first! != "/" ? "/\(path)" : path
    }
    
    static func getFileNameFromPath(fullyQualifiedPathString: String) -> String {
        let pathSegments = fullyQualifiedPathString.split(separator: "/")
        return String(pathSegments.last!)
    }
    
    static func getLanguageFromFileName(fileName: String) -> Language {
        let segs = fileName.split(separator: ".")
        if segs.count == 2 {
            return Language("en-US", true)
        }
        else {
            return Language(String(segs[1]), false)
        }
    }
    
    static func parseFiles(filePath: String) -> [LanguageResource] {
        var resources: [LanguageResource] = []
        var masterKeys: [String] = []
        do {
            let directory = getDirectoryOf(file: filePath)
            for file in try Folder(path: directory).files {
                print(file.name)
                if file.name.contains(".resx") {
                    guard let data = try? Data(contentsOf: URL(fileURLWithPath: "\(directory)/\(file.name)")) else {
                        return resources
                    }
                    let xmlDoc = try AEXMLDocument(xml: data)
                    var entryArray = [ResourceEntry]()
                    
                    if let entries = xmlDoc.root["data"].all {
                        let sorted = entries.sorted(by: { $0.attributes["name"]!.lowercased() < $1.attributes["name"]!.lowercased() })
                        for entry in sorted {
                            
                            entryArray.append(ResourceEntry(key: entry.attributes["name"]!, text: entry["value"].string, isNew: false))
                        }

                        var languageResource = LanguageResource(
                            language: getLanguageFromFileName(fileName: file.name),
                            resources: entryArray,
                            pathToResourceFile: "\(directory)/\(file.name)"
                        )
                        if languageResource.language.isDefault {
                            masterKeys = languageResource.resources.map { $0.key }
                            masterKeys = masterKeys.sorted(by: { $0.lowercased() < $1.lowercased()})
                            languageResource.masterKeys = masterKeys
                        }
                        
                        resources.append(languageResource)
                    }
                    
                    
                    
                }
            }
        } catch  {
            print(error)
        }
        
        let defaultResourceSet = resources.filter { $0.language.isDefault }.first!
        for file in resources {
            if !file.language.isDefault {
                let keys = file.resources.map({$0.key})
                let dif = masterKeys.difference(from: keys)
                
                
                if dif.count > 0 {
                    for key in dif {
                        if !defaultResourceSet.resources.map({$0.key}).contains(key)  {
                            self.writeTo(filePath: defaultResourceSet.pathToResourceFile, entry: ResourceEntry(key: key, text: ""))
                        }
                        if !file.resources.map({$0.key}).contains(key) {
                            self.writeTo(filePath: file.pathToResourceFile, entry: ResourceEntry(key: key, text: ""))
                        }
                    }
                    
                    let nc = NotificationCenter.default
                    nc.post(name: Notification.Name("hasupdates"), object: nil)
                    
                }
            }
        }
        
        resources = resources.sorted(by: { $0.language.isDefault && !$1.language.isDefault })
        
        return resources
    }
    
    static func parseFile(filePath: String) -> [ResourceEntry] {

        var resources: [ResourceEntry] = []
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
            return resources
        }
        
        do {
            let xmlDoc = try AEXMLDocument(xml: data)
            
            if let entries = xmlDoc.root["data"].all {
                for entry in entries {
                    resources.append(ResourceEntry(key: entry.attributes["name"]!, text: entry["value"].string, isNew: false))
                }
            }
            
        } catch  {
            print("\(error)")
        }
        return resources
    }
    
    static func writeTo(filePath: String, entry: ResourceEntry) {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
            return
        }
        
        let url = URL(fileURLWithPath: filePath)
        do {
            let xmlDoc = try AEXMLDocument(xml: data)
            let dataNodes = xmlDoc.root.addChild(name: "data", attributes: ["name": entry.key, "xml:space": "preserve"])
            dataNodes.addChild(name: "value", value: entry.text)

            do {
                try xmlDoc.xml.write(to: URL(fileURLWithPath: url.relativePath), atomically: true, encoding: String.Encoding.utf8)
            } catch {
                print("\(error)")
                // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
            }
            
        } catch  {
            print("\(error)")
        }
    }
    
    static func addEntry(toFile: String, newEntry: ResourceEntry) {
        
        do {
            let directory = getDirectoryOf(file: toFile)
            for file in try Folder(path: directory).files {
                if file.name.contains(".resx") {
                    guard let data = try? Data(contentsOf: URL(fileURLWithPath: "\(directory)/\(file.name)")) else {
                        return
                    }
                    let xmlDoc = try AEXMLDocument(xml: data)
                    let dataNodes = xmlDoc.root.addChild(name: "data", attributes: ["name": newEntry.key, "xml:space": "preserve"])
                    dataNodes.addChild(name: "value", value: newEntry.text)
                    
                    do {
                        try xmlDoc.xml.write(to: URL(fileURLWithPath: toFile), atomically: true, encoding: String.Encoding.utf8)
                    } catch {
                        print("\(error)")
                        // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
                    }
                }
            }

        } catch {
            print(error)
        }
    }
    
    static func updateKey(filePath: String, originalKey: String, updatedEntry: ResourceEntry) {
        do {
            
            let directory = getDirectoryOf(file: filePath)
            for file in try Folder(path: directory).files {
                
                if file.name.contains(".resx") {
                    guard let data = try? Data(contentsOf: URL(fileURLWithPath: "\(directory)/\(file.name)")) else {
                        return
                    }
                    let xmlDoc = try AEXMLDocument(xml: data)
                    
                    if let entries = xmlDoc.root["data"].all {
                        for entry in entries {
                            if entry.attributes["name"]! == originalKey {
                                entry.attributes["name"]! = updatedEntry.key
                            }
                            
                            do {
                                try xmlDoc.xml.write(to: URL(fileURLWithPath: filePath), atomically: true, encoding: String.Encoding.utf8)
                            } catch {
                                print("\(error)")
                                // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
                            }
                        }
                    }
                }
            }
            
        } catch  {
            print("\(error)")
        }
    }
    
    static func updateText(filePath: String, entry: ResourceEntry) {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
            return
        }
        
        do {
            let xmlDoc = try AEXMLDocument(xml: data)
            
            if let entries = xmlDoc.root["data"].all {
                for node in entries {
                    if node.attributes["name"]! == entry.key {
                        node["value"].value = entry.text
                    }
                    
                    do {
                        try xmlDoc.xml.write(to: URL(fileURLWithPath: filePath), atomically: true, encoding: String.Encoding.utf8)
                    } catch {
                        print("\(error)")
                        // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
                    }
                    
                }
            }
            
        } catch  {
            print("\(error)")
        }
    }
    
//    static func updateEntry(filePath: String, originalKey: String, originalText: String, updatedEntry: ResourceEntry) {
//        guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
//            return
//        }
//
//        do {
//            let xmlDoc = try AEXMLDocument(xml: data)
//
//            if let entries = xmlDoc.root["data"].all {
//                for entry in entries {
//                    if entry.attributes["name"]! == originalKey {
//                        entry.attributes["name"]! = updatedEntry.key
//                        if updatedEntry.text != originalText {
//                            entry["value"].value = updatedEntry.text
//                        }
//                    }
//
//                    do {
//                        try xmlDoc.xml.write(to: URL(fileURLWithPath: filePath), atomically: true, encoding: String.Encoding.utf8)
//                    } catch {
//                        print("\(error)")
//                        // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
//                    }
//
//                }
//            }
//
//        } catch  {
//            print("\(error)")
//        }
//    }

//    func writeTo(filePath: String, fileData: FileData) {
//
//        guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
//            return
//        }
//
//        let url = URL(fileURLWithPath: filePath)
//        print(url)
//
//        do {
//            let xmlDoc = try AEXMLDocument(xml: data)
//
//            for item in fileData.resourcesToAdd {
//                let dataNodes = xmlDoc.root.addChild(name: "data", attributes: ["name": item.key])
//                dataNodes.addChild(name: "value", value: item.text)
//                print(dataNodes)
//            }
//
//            do {
//                try xmlDoc.xml.write(to: URL(fileURLWithPath: url.relativePath), atomically: true, encoding: String.Encoding.utf8)
//            } catch {
//                print("\(error)")
//                // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
//            }
//
//
//            print(xmlDoc.xml)
//
//        } catch  {
//            print("\(error)")
//        }
//    }

    static func createTextFile(path: String, name: String, resources: [ResourceEntry] = []) {
        do {
            let folder = try Folder(path: path)
            let file = try folder.createFile(named: name)
            for entry in resources {
                try file.write("\(entry.key) = \(entry.text)\r\n")
            }
            
        } catch {
            print(error)
        }
    }
    
    static func deleteFile(_ file: String) {
        do {
            let file = try File(path: file)
            try file.delete()
        } catch  {
            print(error)
        }
    }
}

