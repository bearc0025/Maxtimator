//
//  ExerciseMax.swift
//  Maxtimator
//
//  Created by Bear on 5/17/24.
//

import Foundation

let dayInMins = 24.0 * 60.0 * 60.0

// MARK: - ExerciseMaxMgr - data for all exercise move max estimates
class ExerciseMaxMgr {
    private(set) var maxEstimator : OneRepMaxEstimator
    private(set) var nameToMax = [String:ExerciseMax]()
    
    init(maxEstimator : OneRepMaxEstimator) {
        self.maxEstimator = maxEstimator
    }
    
    /// Formats a Max PR for a given exercise name with correct precision.
    /// - Parameter name: Name of exercise
    /// - Returns: Formatted string of the max for the given exercise as Int or 1 decimal precision.
    ///
    func formattedMaxPR(for name : String) -> String {
        guard let maxEstimate = nameToMax[name]?.maxEstimate else { return "" }
        if maxEstimate == maxEstimate.rounded(.down) {
            return "\(Int(maxEstimate))"
        }
        return String(format: "%.1f", maxEstimate)
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
        let components = line.components(separatedBy: ",")
        
        guard components.count == 4 else {
            // handle error
            return
        }
        
        let name = components[1]
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
extension ExerciseMax {
    /// Sorted list of all dates for the PRs sorted by date.
    var dateStrings : [String] {
        let dateFmtr = DateFormatter()
        dateFmtr.dateFormat = "MMM dd yyyy"
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
        
        return sortedStrings
    }
}

// MARK: - Calendar util
extension ExerciseMax {
    /// What type of Calendar.Component best matches the number of entries of maxes.
    var calendarScale : Calendar.Component {
        switch dateToMax.count {
        case 0..<10:
            return .day
        default:
            return .month
        }
    }
    
    /// Calculated number of days that best matches the date range of the maxes.
    var dayStride : Int {
        if startDate == nil { let _ = dateStrings }
        guard let startDate, let endDate else { return 99 }
        let timeInterval = endDate.timeIntervalSince(startDate) / dayInMins
        switch timeInterval {
        case ..<14:
            return 2
        case 14..<50:
            return 7
        default:
            return 30
        }
    }
}
