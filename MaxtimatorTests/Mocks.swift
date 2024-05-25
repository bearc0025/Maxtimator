//
//  Mocks.swift
//  MaxtimatorTests
//
//  Created by Bear on 5/25/24.
//

import Foundation
@testable import Maxtimator

class MockDataLoader : Sequence, IteratorProtocol {
    typealias Element = String
    var total = 0
    var lines : [String]
    
    init(total : Int) {
        self.total = total
        lines = setupLines(numLines: total)
    }
    func makeIterator() -> MockDataLoader {
        return self
    }
    func next() -> String? {
        guard lines.isEmpty == false else { return nil }
        return lines.removeFirst()
    }
}

class MockOneRepEst : OneRepMaxEstimator {
    func analyze(set: OneSet) -> Double { return 0.0 }
}

