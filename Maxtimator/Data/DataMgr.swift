//
//  DataMgr.swift
//  Maxtimator
//
//  Created by Bear on 5/17/24.
//

import Foundation

typealias OneSet = (reps:Int,weight:Double)

protocol DataLoader : Observable {
    func loadData() async -> [String]?
}

protocol OneRepMaxEstimator {
    func analyze(sets : [OneSet]) -> Double?
}

@Observable
class DataMgr  {
    var dateNameToData : [String:[OneSet]]
    var dataLoader : (any DataLoader)?
    var repMaxEstimator : OneRepMaxEstimator?

    init(dataLoader : DataLoader, repMaxEstimator : OneRepMaxEstimator) {
        self.dataLoader = dataLoader
        self.repMaxEstimator = repMaxEstimator
        self.dateNameToData = [String:[OneSet]]()
        Task {
            await loadData()
        }
    }
    
    func loadData() async {
        guard let dataStrings = await dataLoader?.loadData() else {
            // handle error
            return
        }
        
        let tups = dataStrings.compactMap { parse(line: $0) }
        for tup in tups {
            var sets = dateNameToData[tup.uid] ?? [OneSet]()
            sets.append(tup.set)
            dateNameToData[tup.uid] = sets
        }
    }
    
    func parse(line : String) -> (uid:String,set:OneSet)? {
        let components = line.components(separatedBy: ",")
        
        guard components.count == 4 else {
            // handle error
            return nil
        }

        let uid = components[0] + "|" + components[1]
        
        guard let reps = Int(components[2]) else {
            // handle error
            return nil
        }
        guard let weight = Double(components[3]) else {
            // handle error
            return nil
        }
        
        return (uid, (reps,weight))
    }
}


