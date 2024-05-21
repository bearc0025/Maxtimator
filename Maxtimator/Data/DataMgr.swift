//
//  DataMgr.swift
//  Maxtimator
//
//  Created by Bear on 5/17/24.
//

import Foundation

typealias OneSet = (reps:Int,weight:Double)

// MARK: - Protocol to define the interface for estimating a 1-rep max
protocol OneRepMaxEstimator {
    func analyze(set : OneSet) -> Double
}

// MARK: - Main data management class to process data loaded
class DataMgr : ObservableObject {
    private(set) var exerciseMaxMgr : ExerciseMaxMgr

    /// Takes a data loader sequence and 1 rep max estimator
    /// - Parameter dataLoader: Sequence to process data lines
    /// - Parameter repMaxEstimator: Object to estimate 1 rep max based on the OneRepMaxEstimator protocol.
    init(dataLoader : any Sequence<String>, repMaxEstimator : OneRepMaxEstimator) {
        exerciseMaxMgr = ExerciseMaxMgr(maxEstimator: repMaxEstimator)
        dataLoader.forEach { exerciseMaxMgr.process(line: $0) }
    }
}


