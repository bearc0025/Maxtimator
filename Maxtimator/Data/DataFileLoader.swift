//
//  DataFileLoader.swift
//  Maxtimator
//
//  Created by Bear on 5/17/24.
//

import Foundation

let FILENAME = "workoutData.txt"
let FileSizeSm = 1024*1024

class DataFileLoader : Sequence, IteratorProtocol {
    typealias Element = String
    
    // a pointer to a null-terminated, UTF-8 encoded sequence of bytes
    var lineCharPointer: UnsafeMutablePointer<CChar>? = nil
    var filePointer : UnsafeMutablePointer<FILE>?
    var lineCap: Int = 0
    
    var hasMoreData = true
    var fileLines : [String]?
    var lineIndex = 0
    
    /// Initializes the object by opening the workout data file
    init() {
        guard let fileURL = Bundle.main.url(forResource: FILENAME, withExtension: nil) else {
            // handle error
            return
        }
        
        // file exists
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            // handle error
            return
        }
        
        // for smaller files, read in all contents
        // if any of this is false, go to reading in the file by lines
        if let fileSize = fileURL.fileSize, fileSize < FileSizeSm {
            // read in data, convert to Strings and separate lines
            if let data = try? Data(contentsOf: fileURL),
                let dataStr = String(data: data, encoding: .utf8) {
                    fileLines = dataStr.components(separatedBy: "\n")
                    return
            }
        }
        
        // open the file for reading (line by line)
        filePointer = fopen(fileURL.path,"r")
    }
    
    /// Close the file and clean up memory
    deinit {
        fclose(filePointer)
        lineCharPointer?.deallocate()
    }

    /// Interate over the data (String) cached or read in from file.
    /// - Returns: String - the next line in the data (file in the case of this instance)
    func next() -> String? {
        // if cached...
        guard fileLines == nil else { return nextCachedLine() }
        
        // ...else read in.
        return nextReadLine()
    }
    
    func nextCachedLine() -> String? {
        // this cd just return the next item (next line) in the list but we may want the cached data
        //        fileLines?.remove(at: lineIndex)
        
        // check for, and return, next line with index
        var line : String? =  nil
        if let fileLines = fileLines, lineIndex < fileLines.count {
            line = fileLines[lineIndex]
            lineIndex += 1
        }
        return line
    }
    
    func nextReadLine() -> String? {
        guard hasMoreData else { return nil }
        hasMoreData = getline(&lineCharPointer, &lineCap, filePointer) > 0
        
        // bytes -> string (UTF-8), remove \n
        return String(cString:lineCharPointer!)
            .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /// Use this same object as the Sequence and Interator
    func makeIterator() -> DataFileLoader {
        return self
    }
}
