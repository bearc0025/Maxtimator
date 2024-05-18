//
//  DataFileLoader.swift
//  Maxtimator
//
//  Created by Bear on 5/17/24.
//

import Foundation

let FILENAME = "workoutData.txt"

class DataFileLoader : Sequence, IteratorProtocol {
    typealias Element = String
    
    // a pointer to a null-terminated, UTF-8 encoded sequence of bytes
    var lineCharPointer: UnsafeMutablePointer<CChar>? = nil
    var filePointer : UnsafeMutablePointer<FILE>?
    var lineCap: Int = 0
    
    var hasMoreData = true
    
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
        
        // open the file for reading
        filePointer = fopen(fileURL.path,"r")
    }
    
    /// Close the file and clean up memory
    deinit {
        fclose(filePointer)
        lineCharPointer?.deallocate()
    }

    /// Interate over the data (String)
    /// - Returns: String - the next line in the data (file in the case of this instance)
    func next() -> String? {
        guard hasMoreData else { return nil }
        hasMoreData = getline(&lineCharPointer, &lineCap, filePointer) > 0
        
        // bytes -> string (UTF-8), remove \n
        return String.init(cString:lineCharPointer!).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /// Use this same object as the Sequence and Interator
    func makeIterator() -> DataFileLoader {
        return self
    }
}
