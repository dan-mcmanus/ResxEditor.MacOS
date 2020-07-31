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

    
    static func generateDesignerFile(resxFile: String, nameSpace: String, className: String, designerFileName: String) {
        let templatesFolder = #file.replacingOccurrences(of: "Services", with: "Templates")  // <-- this is surprisingly difficult to do
            .replacingOccurrences(of: "ResXFileCodeGenerator.swift", with: "")

        let resourcesFolder = FileUtility.getDirectoryOf(file: resxFile)
        print(resourcesFolder)
        let headerTemplatePath = "\(templatesFolder)HeaderTemplate.txt"
        let elementTemplatePath = "\(templatesFolder)ElementTemplate.txt"
        
        var fileData = ""
        var newFileDict: [String: String] = [String: String]()
        
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: resxFile)) else {
            return
        }
        
        do {
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
                .replacingOccurrences(of: "{namespace}", with: nameSpace)
                .replacingOccurrences(of: "{classname}", with: className)
                .replacingOccurrences(of: "{elementdata}", with: fileData)
        
            
            let folder = try Folder(path: FileUtility.getDirectoryOf(file: resxFile))
            let file = try folder.createFile(named: designerFileName)
            try file.write(designerFile)
        } catch  {
            print("\(error)")
        }
    }
    
}
