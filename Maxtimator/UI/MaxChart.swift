//
//  MaxChart.swift
//  Maxtimator
//
//  Created by Bear on 5/18/24.
//

import SwiftUI
import Charts

// MARK: - Simple singleton class to process date label strings
class LabelDate {
    static var shared = LabelDate()
    var dateFmtr = DateFormatter()
    
    private init() {
        dateFmtr.dateFormat = "MMM dd yyyy"
    }
    
    func date(for dateString : String) -> Date {
        dateFmtr.date(from: dateString) ?? .now
    }
}

// MARK: - Rep max estimate chart UI
struct MaxPRChart : View {
    var exerciseMax : ExerciseMax
    let labelDate = LabelDate.shared
    
    var body: some View {
        Chart {
            // get the date strings and chart
            ForEach(Array(exerciseMax.dateStrings), id:\.self) { date in
                LineMark(
                    x: .value("Date", labelDate.date(for: date)),
                    y: .value("Weight", exerciseMax.dateToMax[date]!)
                )
                PointMark(
                    x: .value("Date", labelDate.date(for: date)),
                    y: .value("Weight", exerciseMax.dateToMax[date]!)
                )
                .symbol {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(1))
                            .frame(width: 6)
                        Circle()
                            .fill(Color.black.opacity(1))
                            .frame(width: 3)
                    }
                }
            }
        }
        .chartXAxis {
            let calScale = exerciseMax.calendarScale
            let dayStride = exerciseMax.dayStride
            AxisMarks(values: .stride(by: .day, count: dayStride)) { value in
                switch calScale {
                case .day:
                    AxisValueLabel(format: .dateTime.month().day())
                default:
                    AxisValueLabel(format: .dateTime.month())
                }
            }
        }
        .chartYAxis {
            AxisMarks(values: .automatic(desiredCount: 3))
        }
    }
    
}
