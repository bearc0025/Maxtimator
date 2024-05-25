//
//  RepMaxEstimator.swift
//  Maxtimator
//
//  Created by Bear on 5/17/24.
//

import Foundation

// MARK: - Brzycki 1-rep max estimator
// see https://en.wikipedia.org/wiki/One-repetition_maximum
class BrzyckiRepMaxEstimator : OneRepMaxEstimator {
    func analyze(set: OneSet) -> Double {
        let w = set.weight
        let r = set.reps
        
        guard w > 0, r > 0 else { return 0.0 }
        
        let maxEst = w * (36.0 / (37.0 - Double(r)))
        
        return maxEst
    }
}
