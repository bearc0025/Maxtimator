//
//  MaxtimatorTests.swift
//  MaxtimatorTests
//
//  Created by Bear on 5/17/24.
//

import XCTest
@testable import Maxtimator

final class MaxtimatorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDataLoader() throws {
        let dl = DataFileLoader()
        let dataStrings = dl.loadData()
        XCTAssertNotNil(dataStrings, "dataStrings sd not be nil")
        XCTAssertEqual(dataStrings!.count, 582, "dataStrings sd have 583 values")
    }

    class MockDataLoader : DataLoader {
        func loadData() async -> [String]? { nil }
    }
    class MockOneRepEst : OneRepMaxEstimator {
        func analyze(set: Maxtimator.OneSet) -> Double? { return nil }
    }

    func testLineParser() throws {
        let str = "Oct 11 2020,Back Squat,10,45"
        let dataMgr = DataMgr(dataLoader: MockDataLoader(), repMaxEstimator: MockOneRepEst())
        let parsed = dataMgr.parse(line: str)
        XCTAssertNotNil(parsed, "parsed sd not be nil")
        XCTAssertEqual(parsed!.uid, "Oct 11 2020|Back Squat", "name sd be Oct 11 2020|Back Squat")
        XCTAssertEqual(parsed!.set.reps, 10, "reps sd be 10")
        XCTAssertEqual(parsed?.set.weight, 45.0, "weight sd be 45")
    }
    
    func testFileLoader() async throws {
        let dfl = DataFileLoader()
        let strings = dfl.loadData()
        XCTAssertNotNil(strings, "strings sd not be nil")
        XCTAssertEqual(strings!.count, 582, "sd have 582 items")
    }
    
    func testDataMgr() async throws {
        let dataMgr = DataMgr(dataLoader: DataFileLoader(), repMaxEstimator: MockOneRepEst())
        await dataMgr.loadData()
        XCTAssertNotNil(dataMgr.dateNameToData, "dataNameToData sd not be nil")
//        XCTAssertEqual(dataMgr.dateNameToData.count, 88, "sd have 88 items")
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
