//
//  BrzyckiTests.swift
//  MaxtimatorTests
//
//  Created by Bear on 5/25/24.
//

import XCTest
@testable import Maxtimator

final class BrzyckiTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEstimator() throws {
        let estimator = BrzyckiRepMaxEstimator()
        var set = (6,145.0)
        var result = estimator.analyze(set: set)
        XCTAssertEqual(result, 168.39, accuracy: 0.05, "sd be 168 +/- 0.5")

        set = (0,145.0)
        result = estimator.analyze(set: set)
        XCTAssertEqual(result, 0, accuracy: 0.05, "sd be 0 +/- 0.5")
        
        set = (10,0.0)
        result = estimator.analyze(set: set)
        XCTAssertEqual(result, 0, accuracy: 0.05, "sd be 0 +/- 0.5")
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
