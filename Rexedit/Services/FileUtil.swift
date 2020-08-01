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
    
    static func updateEntry(filePath: String, originalKey: String, originalText: String, updatedEntry: ResourceEntry) {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
            return
        }
        
        do {
            let xmlDoc = try AEXMLDocument(xml: data)
            
            if let entries = xmlDoc.root["data"].all {
                for entry in entries {
                    if entry.attributes["name"]! == originalKey {
                        entry.attributes["name"]! = updatedEntry.key
                    }
                    
                    if entry["value"].value == originalText {
                        entry["value"].value = updatedEntry.text
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
    
    func writeTo(filePath: String, fileData: FileData) {
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
            return
        }
        
        let url = URL(fileURLWithPath: filePath)
        print(url)
        
        do {
            let xmlDoc = try AEXMLDocument(xml: data)
            
            for item in fileData.resourcesToAdd {
                let dataNodes = xmlDoc.root.addChild(name: "data", attributes: ["name": item.key])
                dataNodes.addChild(name: "value", value: item.text)
                print(dataNodes)
            }
            
            do {
                try xmlDoc.xml.write(to: URL(fileURLWithPath: url.relativePath), atomically: true, encoding: String.Encoding.utf8)
            } catch {
                print("\(error)")
                // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
            }
            
            
            print(xmlDoc.xml)
            
        } catch  {
            print("\(error)")
        }
    }

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

