//
//  DataFileLoaderTests.swift
//  MaxtimatorTests
//
//  Created by Bear on 5/25/24.
//

import XCTest
@testable import Maxtimator

final class DataFileLoaderTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFileLoader() async throws {
        let dfl = DataFileLoader()
        let iterator = dfl.makeIterator()
        for line in iterator {
            print(line)
        }
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
