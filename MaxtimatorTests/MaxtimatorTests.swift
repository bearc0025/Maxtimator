//
//  MaxtimatorTests.swift
//  MaxtimatorTests
//
//  Created by Bear on 5/17/24.
//

import XCTest
@testable import Maxtimator

func setupLines(numLines : Int) -> [String] {
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    let moves = ["Back 1", "Back 2", "Bicep 1", "Bicep 2", "Leg 1", "Leg 2"]
    
    var month : String { months[Int.random(in: 0..<months.count)] }
    var day : String { "\(Int.random(in: 1..<29))" }
    var move : String { moves[Int.random(in: 0..<moves.count)] }
    
    var reps : String { "\(Int.random(in: 4..<15))" }
    var weight : String { "\(Int.random(in: 85..<200))" }
    
    var lines = [String]()
    (0..<numLines).forEach { _ in
        let line = "\(month) \(day) 2020, \(move), \(reps), \(weight)"
        lines.append(line)
    }
    return lines
}


final class MaxtimatorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    class MockDataLoader : Sequence, IteratorProtocol {
        typealias Element = String
        var total = 0
        var lines : [String]
        
        init(total : Int) {
            self.total = total
            lines = setupLines(numLines: total)
        }
        func makeIterator() -> MaxtimatorTests.MockDataLoader {
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

    func testFileLoader() async throws {
        let dfl = DataFileLoader()
        let iterator = dfl.makeIterator()
        for line in iterator {
            print(line)
        }
    }
    
    func testBrzychi() throws {
        let repEst = BrzyckiRepMaxEstimator()
        let set = (reps:6, weight:245.0)
        let max = repEst.analyze(set: set)
        XCTAssertEqual(max, 284.52, accuracy: 0.05, "sd be 284.52")
    }
    
    func testExMax() throws {
        let exMax = ExerciseMax()
        exMax.process(components: ["Oct 11 2020","Back Squat","6","245"], 
                      maxEstimator: BrzyckiRepMaxEstimator())
        XCTAssertEqual(exMax.dateToMax.count, 1, "sd have 1 item")
        XCTAssertEqual(exMax.dateToMax.keys.first, "Oct 11 2020")
        XCTAssertEqual(exMax.dateToMax.values.first!, 284.52, accuracy: 0.05, "sd be 284")
        exMax.process(components: ["Oct 11 2020","Back Squat","6","255"], 
                      maxEstimator: BrzyckiRepMaxEstimator())
        XCTAssertEqual(exMax.dateToMax.count, 1, "sd have 1 item")
        XCTAssertEqual(exMax.dateToMax.keys.first, "Oct 11 2020")
        XCTAssertEqual(exMax.dateToMax.values.first!, 296.13, accuracy: 0.05, "sd be 296")
        exMax.process(components: ["Nov 11 2020","Back Squat","6","255"], 
                      maxEstimator: BrzyckiRepMaxEstimator())
        XCTAssertEqual(exMax.dateToMax.count, 2, "sd have 2 item2")
    }

    func testExMaxMgr() throws {
        let exMaxMgr = ExerciseMaxMgr(dataLoader: MockDataLoader(total: 0),
                                      maxEstimator: BrzyckiRepMaxEstimator())
        let line1 = "Oct 11 2020,Back Squat,10,45"
        exMaxMgr.process(line: line1)
        XCTAssertEqual(exMaxMgr.nameToMax.count, 1, "sd have 1 exMax")
        XCTAssertEqual(exMaxMgr.nameToMax.keys.first, "Back Squat", "sd be back squat")
        let line2 = "Oct 11 2020,Deadlift,20,65"
        exMaxMgr.process(line: line2)
        XCTAssertEqual(exMaxMgr.nameToMax.count, 2, "sd have 2 exMax")
    }
    
    func testExMaxMgrLines() throws {
        let mockDL = MockDataLoader(total: 2)
        let exMaxMgr = ExerciseMaxMgr(dataLoader: mockDL,
                                      maxEstimator: BrzyckiRepMaxEstimator())
        XCTAssertEqual(exMaxMgr.nameToMax.count, 2, "sd have 2 exMax")
    }
    

    func testPerformanceDataLoading() throws {
        let exerciseMaxMgr = ExerciseMaxMgr(dataLoader: DataFileLoader(), 
                                            maxEstimator: BrzyckiRepMaxEstimator())

        let lines = setupLines(numLines: 100000)
        self.measure {
            lines.forEach { exerciseMaxMgr.process(line: $0) }
        }
    }

    func testPerformanceKeySortingLoading() throws {
        let exerciseMaxMgr = ExerciseMaxMgr(dataLoader: DataFileLoader(),
                                            maxEstimator: BrzyckiRepMaxEstimator())
        
        let lines = setupLines(numLines: 100000)
        lines.forEach { exerciseMaxMgr.process(line: $0) }

        self.measure {
            exerciseMaxMgr.nameToMax.values.forEach { exMex in
                _ = exMex.sortedDateStrings
            }
        }
    }

}
