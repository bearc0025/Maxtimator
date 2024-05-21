//
//  RepMaxEstimator.swift
//  Maxtimator
//
//  Created by Bear on 5/17/24.
//

import Foundation

// see https://en.wikipedia.org/wiki/One-repetition_maximum 
class BrzyckiRepMaxEstimator : OneRepMaxEstimator {
    func analyze(set: OneSet) -> Double {
        let w = set.weight
        let r = set.reps
        
        let maxEst = w * (36.0 / (37.0 - Double(r)))
        
        return maxEst
    }
}
