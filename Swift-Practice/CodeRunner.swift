//
//  CodeRunner.swift
//  Swift-Practice
//
//  Created by Ibrahim Hassan on 08/05/22.
//

import Foundation

extension String {
    static let fileName = "code.swift"
    static let swiftTaskPath = "/usr/bin/swift"
}

class CodeRunner: ObservableObject {
    @Published var output: String = ""
    @Published var error: String = ""
    
    func runCode(_ code: String) {
        let filename = getDocumentDirectory().appendingPathComponent(.fileName)

        do {
            try code.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print (error)
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }

        let task = Process()
        task.executableURL = URL(fileURLWithPath: .swiftTaskPath)
        
        task.arguments = [filename.path]
        
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        
        task.standardOutput = outputPipe
        task.standardError = errorPipe

        do {
            try task.run()
        } catch {
        }
        
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()

        output = String(decoding: outputData, as: UTF8.self)
        processErrorMessage(String(decoding: errorData, as: UTF8.self))
    }
    
    func processErrorMessage(_ errorString: String) {
        let stringDroppingFirstLine = errorString.components(separatedBy: "\n").dropFirst().joined(separator: "\n")
        
        error = stringDroppingFirstLine.replacingOccurrences(
            of: "\(getDocumentDirectory().appendingPathComponent(.fileName).path):", with: "")
    }
    
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
