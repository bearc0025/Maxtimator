//
//  DataMgr.swift
//  Maxtimator
//
//  Created by Bear on 5/17/24.
//

import Foundation

typealias OneSet = (reps:Int,weight:Double)

protocol OneRepMaxEstimator {
    func analyze(set : OneSet) -> Double
}

class DataMgr : ObservableObject {
    private(set) var exerciseMaxMgr : ExerciseMaxMgr

    /// Takes a data loader sequence and 1 rep max estimator
    /// - Parameter dataLoader: Sequence to process data lines
    /// - Parameter repMaxEstimator: Object to estimate 1 rep max.
    init(dataLoader : any Sequence<String>, repMaxEstimator : OneRepMaxEstimator) {
        exerciseMaxMgr = ExerciseMaxMgr(maxEstimator: repMaxEstimator)
        dataLoader.forEach { exerciseMaxMgr.process(line: $0) }
    }
}


