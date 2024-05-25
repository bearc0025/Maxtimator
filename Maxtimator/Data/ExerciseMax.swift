//
//  ExerciseMax.swift
//  Maxtimator
//
//  Created by Bear on 5/17/24.
//

import Foundation
import Charts

let dayInMins = 24.0 * 60.0 * 60.0
let DateFormat = "MMM dd yyyy"

typealias OneSet = (reps:Int,weight:Double)

// MARK: - Protocol to define the interface for estimating a 1-rep max
protocol OneRepMaxEstimator {
    func analyze(set : OneSet) -> Double
}

// MARK: - ExerciseMaxMgr - data for all exercise move max estimates
class ExerciseMaxMgr : Observable {
    private(set) var maxEstimator : OneRepMaxEstimator
    private(set) var nameToMax = [String:ExerciseMax]()
    private(set) var dataLoader : any Sequence<String>

    /// Initializer that takes the data loader and estimator.
    /// It will process the lines from the data loader using the estimator when initialized.
    ///
    /// The data loader is a Sequence of type String with the format below.
    ///
    /// 4 items: date, name, reps, weight. Example:
    ///
    ///     Oct 11 2020,Back Squat,10,45
    init(dataLoader : any Sequence<String>, maxEstimator : OneRepMaxEstimator) {
        self.dataLoader = dataLoader
        self.maxEstimator = maxEstimator
        processLines()
    }
    
    /// Formats a Max PR for a given exercise name with correct precision.
    /// - Parameter name: Name of exercise
    /// - Returns: Formatted string of the max for the given exercise as Int or 1 decimal precision.
    ///
    func formattedMaxPR(for name : String) -> String {
        guard let maxEstimate = nameToMax[name]?.maxEstimate else { return "" }
        return "\(Int(maxEstimate))"
    }
    
    /// Takes a data loader sequence and 1 rep max estimator
    /// - Parameter dataLoader: Sequence to process data lines
    /// - Parameter repMaxEstimator: Object to estimate 1 rep max based on the OneRepMaxEstimator protocol.
    func processLines() {
        dataLoader.forEach { process(line: $0) }
        nameToMax.values.forEach {
            $0.sortDateStrings()
            $0.prepMinMax()
        }
    }
    
    /// Analyzes the line to determine if it is a PR and stores it for that exercise.
    ///
    /// Takes a line (String) and parses it into the 4 items: date, name, reps, weight.
    ///
    ///     Oct 11 2020,Back Squat,10,45
    ///
    /// - Parameter line: Comma separated line of exercise information.
    ///
    func process(line : String) {
        // NOTE: This could potentially be a performance hit for large data sets.
        guard let regex = try? Regex("\\s*,\\s*") else {
            // handle error
            return
        }
        let lineMassaged = line.replacing(regex, with: ",")
        
        let components = lineMassaged.components(separatedBy: ",")
        
        guard components.count == 4 else {
            // handle error
            return
        }
        
        // Based on the exercise name...
        let name = components[1]
        // Find the ExerciseMax instance (or create one) to process the data.
        let exerciseMax = nameToMax[name] ?? ExerciseMax()
        exerciseMax.process(components: components, maxEstimator: maxEstimator)
        nameToMax[name] = exerciseMax
    }
}

// MARK: - ExerciseMax - data for a given exercise
class ExerciseMax {
    private(set) var maxEstimate = 0.0
    private(set) var dateToMax = [String:Double]()
    private var startDate : Date?
    private var endDate : Date?
    private let dateFmtr = DateFormatter()
    private(set) var minVal = 99999
    private(set) var maxVal = 0

    private(set) var sortedDateStrings = [String]()
    
    init() {
        dateFmtr.dateFormat = DateFormat
        dateFmtr.timeZone = TimeZone(identifier: "GMT")
    }
    
    /// Processes an array of Strings of a given line being processed.
    /// Components: date, name, reps, weight
    /// Uses the passed in max estimator to determine 1 rep max for data.
    /// Stores the estimate as the max if there isn't one or it's larger than the current value.
    /// Stores the estimate as the overall max if larger than the current.
    ///  - Parameter components: String array (4) of date (MMM dd yyyy), name, reps and weight
    ///  - Parameter maxEstimator: 1 rep max estimator for reps and weight.
    func process(components : [String], maxEstimator : OneRepMaxEstimator) {
        guard components.count == 4 else {
            // handle error
            return
        }
        
        guard let reps = Int(components[2]) else {
            // handle error
            return
        }
        guard let weight = Double(components[3]) else {
            // handle error
            return
        }
        
        let date = components[0]
        
        let checkMax = maxEstimator.analyze(set: (reps,weight))

        if dateToMax[date] == nil || dateToMax[date]! < checkMax {
            dateToMax[date] = checkMax
        }

        maxEstimate = max(checkMax, maxEstimate)
    }
}

// MARK: - Sorted date strings for the loaded data
extension ExerciseMax : DateValueChartDelegate {
    /// Formatted date String for delegate protocol.
    /// The string passed in should be obtained from sortedDateStrings.
    /// - Parameter date: String of a Date to be converted.
    /// - Returns: Date instance for given string.
    func date(for dateString: String) -> Date {
        dateFmtr.date(from: dateString) ?? .now
    }
    
    /// The value related to the given date String passed in.
    /// - Parameter date: The date string (from sortedDateStrings) to find a value for.
    /// - Returns: Double value related to the date passed in.
    func value(for date: String) -> Double {
        dateToMax[date] ?? 0.0
    }
    
    /// Sorted list of all dates for the PRs sorted by date.
    func sortDateStrings() {
        let sortedStrings = dateToMax.keys
            .sorted {
                guard let d1 = dateFmtr.date(from: $0),
                      let d2 = dateFmtr.date(from: $1) else { return true }
                return d1 < d2
            }
        
        if let first = sortedStrings.first, let last = sortedStrings.last {
            startDate = dateFmtr.date(from: first)
            endDate = dateFmtr.date(from: last)
        }
        
        sortedDateStrings = sortedStrings
    }
 
    /// Prep min/max values for charting Y axis.
    func prepMinMax() {
        var minComp = 9999.0
        var maxComp = 0.0
        dateToMax.values.forEach { val in
            minComp = min(minComp, val)
            maxComp = max(maxComp, val)
        }
        
        // lower/raise the min/max for better chart Y axis range
        minVal = Int(minComp - 25.0)
        maxVal = Int(maxComp + 25.0)
    }

    /// What type of Calendar.Component best matches the number of entries of maxes.
    /// - Returns: Calendar.Component for the chart.
    var calendarScale : Calendar.Component {
        switch dateToMax.count {
        case 0..<10:
            return .day
        default:
            return .month
        }
    }
    
    /// Calculated number of days that best matches the date range of the maxes.
    /// - Returns: Int day stride for the chart.
    var chartStride : Int {
        guard calendarScale != .day else { return 2 }
        guard let startDate, let endDate else { return 99 }

        let months = endDate.timeIntervalSince(startDate) / dayInMins / 30
        return Int(months) / 5
    }
}
