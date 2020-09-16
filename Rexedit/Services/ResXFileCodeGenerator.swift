//
//  ResXFileCodeGenerator.swift
//  RexEdit
//
//  Created by Daniel McManus on 7/31/20.
//

import Foundation
import AEXML
import Files

class ResXFileCodeGenerator {

    static func checkForDesignerFile(filePath: String) -> Bool {
        var exists = false
        let folder = FileUtil.getDirectoryOf(file: filePath)
        
        do {
            for file in try Folder(path: folder).files {
                if file.name.contains(".Designer.cs") {
                    exists = true
                }
            }
        } catch {
            print(error)
        }
        
        return exists
    }
    
    static func getNamespace(designerFile: String) -> String {
        var ns = ""
        let resourcesFolder = FileUtil.getDirectoryOf(file: designerFile)
        
        do {
            for file in try Folder(path: resourcesFolder).files {
                if file.name.contains(".Designer.cs") {
                    let designerFile = try file.readAsString()
                    let lines = designerFile.split(whereSeparator: \.isNewline)
                    for line in lines {
                        if line.contains("namespace ") {
                            print(line)
                            let segs = line.split(separator: " ")
                            ns = String(segs[1])
                        }
                    }
                }
            }
        } catch  {
            print(error)
        }
        return ns
    }
    
    static func getClassName(designerFile: String) -> String {
        var className = ""
        let resourcesFolder = FileUtil.getDirectoryOf(file: designerFile)
        
        do {
            for file in try Folder(path: resourcesFolder).files {
                if file.name.contains(".Designer.cs") {
                    let designerFile = try file.readAsString()
                    let lines = designerFile.split(whereSeparator: \.isNewline)
                    for line in lines {
                        if line.contains("internal class ") || line.contains("public class ") {
                            
                            let segs = line.split(separator: " ")
                            className = String(segs[2])
                            print(className)
                        }
                    }
                }
            }
        } catch  {
            print(error)
        }
        return className
    }
    
    static func createDesignerFile(folder: String, fileName: String) {
        do {
            let folder = try Folder(path: folder)
            let file = try folder.createFile(named: "\(fileName).Designer.cs")
            try file.write("{\"hello\": \"world\"}")
        } catch {
            print(error)
        }
    }
    
    static func generateDesignerFile(resxFile: String, nameSpace: String, className: String, designerFileName: String, modifier: String) {
        print("resxFile: " + resxFile)
        print("" + nameSpace)
        
        if className == "" {
            let cName = getClassName(designerFile: resxFile)
            print("classname" + cName)
        }

        print("" + designerFileName)
        print("" + modifier)
        let templatesFolder = #file.replacingOccurrences(of: "Services", with: "Templates")  // <-- this is surprisingly difficult to do
            .replacingOccurrences(of: "ResXFileCodeGenerator.swift", with: "")

        let resourcesFolder = FileUtil.getDirectoryOf(file: resxFile)

        let headerTemplatePath = "\(templatesFolder)Template.txt"
        let elementTemplatePath = "\(templatesFolder)ElementTemplate.txt"
        
        var fileData = ""
        var newFileDict: [String: String] = [String: String]()
        
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: resxFile)) else {
            return
        }
        
        do {
            var hasDesignerFile = false
            for file in try Folder(path: resourcesFolder).files {
                if file.name.contains(".Designer.cs") {
                    hasDesignerFile = true
                }
            }
            
            if !hasDesignerFile {
                createDesignerFile(folder: resourcesFolder, fileName: resxFile)
            }

            let resxDoc = try AEXMLDocument(xml: data)

            if let entries = resxDoc.root["data"].all {
                for entry in entries {
                    newFileDict.updateValue(entry["value"].string, forKey: entry.attributes["name"]!)
                }
            }

            for kvp in newFileDict {
                do {
                    fileData += try String(contentsOfFile: elementTemplatePath)
                        .replacingOccurrences(of: "{name}", with: kvp.key)
                        .replacingOccurrences(of: "{value}", with: kvp.value)
                } catch  {
                    print(error)
                }
                        
            }
            
            let designerFile = try String(contentsOfFile: headerTemplatePath)
                .replacingOccurrences(of: "{modifier}", with: modifier)
                .replacingOccurrences(of: "{namespace}", with: nameSpace)
                .replacingOccurrences(of: "{classname}", with: className)
                .replacingOccurrences(of: "{elementdata}", with: fileData)
        
            
            let folder = try Folder(path: FileUtil.getDirectoryOf(file: resxFile))
            let file = try folder.createFile(named: designerFileName)
            try file.write(designerFile)
        } catch  {
            print("\(error)")
        }
    }
    
}
