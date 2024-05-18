//
//  DataFileLoader.swift
//  Maxtimator
//
//  Created by Bear on 5/17/24.
//

import Foundation

let FILENAME = "workoutData.txt"

class DataFileLoader : DataLoader {
    let fileURL = Bundle.main.url(forResource: FILENAME, withExtension: nil)
    
    func loadData() -> [String]? {
        guard let fileURL else {
            // handle error
            return nil
        }
        
        do {
            let data = try Data.init(contentsOf: fileURL)
            
            guard let dataString = String(data: data, encoding: .utf8) else {
                // handle error
                return nil
            }
            
            return dataString
                .split(separator: "\n")
                .map { "\($0)" }
        } catch {
            // handle error
            print(error)
            return nil
        }
    }
}
