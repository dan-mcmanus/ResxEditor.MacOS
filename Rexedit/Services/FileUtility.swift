//
//  ResourceParser.swift
//  Rexedit
//
//  Created by Daniel McManus on 7/19/20.
//

import Foundation
import AEXML
import SwiftUI

class FileUtility {
    
    func parseFile(filePath: String) -> [String: String] {
        var resources: [String: String] = [:]
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
            return resources
        }

        do {
            let xmlDoc = try AEXMLDocument(xml: data)
            
            if let entries = xmlDoc.root["data"].all {
                for entry in entries {
                    print(entry.attributes["name"]!)
                    print(entry["value"].string)
                    resources.updateValue(entry["value"].string, forKey: entry.attributes["name"]!)
                    
                }
            }

        } catch  {
            print("\(error)")
        }
        return resources
    }
    
    func writeTo(filePath: String, entry: ResourceEntry) {
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
            print(xmlDoc.xml)
            
        } catch  {
            print("\(error)")
        }
    }
    
    func updateEntry(filePath: String, originalKey: String, originalText: String, updatedEntry: ResourceEntry) {
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
            
//            for (key, value) in entries {
//                let dataNodes = xmlDoc.root.addChild(name: "data", attributes: ["name": key])
//                dataNodes.addChild(name: "value", value: value)
//                print(dataNodes)
//            }
            
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

}
