//
//  ResGenUtility.swift
//  RexEdit
//
//  Created by Daniel McManus on 7/22/20.
//

import Foundation
protocol CommandExecuting {
    func run(commandName: String, arguments: [String]) -> String?
}

struct Bash: CommandExecuting {
    
    // MARK: - CommandExecuting
    
    func run(commandName: String, arguments: [String] = []) -> String? {
        guard var bashCommand = run(command: "/bin/bash" , arguments: ["-l", "-c", "which \(commandName)"]) else { return "\(commandName) not found" }
        bashCommand = bashCommand.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        return run(command: bashCommand, arguments: arguments)
    }
    
    // MARK: Private
    
    private func run(command: String, arguments: [String] = []) -> String? {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: command)
        process.arguments = arguments
        let outputPipe = Pipe()
        process.standardOutput = outputPipe
        
        do {
            try process.run()
        } catch  {
            print(error)
        }

        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(decoding: outputData, as: UTF8.self)
        return output
    }
    
    static func execute(command: String, arguments: [String] = []) {
        let bash: CommandExecuting = Bash()
        
        if let lsOutput = bash.run(commandName: "resgen", arguments: arguments) {
            print(lsOutput)
        } else {
            print("failed")
        }
        
//        if let lsWithArgumentsOutput = bash.run(commandName: "ls", arguments: ["-la"]) {
//            print(lsWithArgumentsOutput)
//        }
    }
}

