//
//  MaxChart.swift
//  Maxtimator
//
//  Created by Bear on 5/18/24.
//

import SwiftUI
import Charts

// MARK: - Protocol to supply information for the DateValueChart UI.
protocol DateValueChartDelegate {
    var sortedDateStrings : [String] { get }
    var calendarScale : Calendar.Component { get }
    var dayStride : Int { get }
    func dateString(for date : String) -> Date
    func value(for date : String) -> Double
}

// MARK: - Rep max estimate chart UI
struct DateValueChart : View {
    var chartDataSource : DateValueChartDelegate
    let labelDate = LabelDate.shared
    
    var body: some View {
        Chart {
            // get the date strings and chart
            ForEach(Array(chartDataSource.sortedDateStrings), id:\.self) { date in
                LineMark(
                    x: .value("Date", chartDataSource.dateString(for: date)),
                    y: .value("Weight", chartDataSource.value(for: date))
                )
                PointMark(
                    x: .value("Date", chartDataSource.dateString(for: date)),
                    y: .value("Weight", chartDataSource.value(for: date))
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
            let calScale = chartDataSource.calendarScale
            let dayStride = chartDataSource.dayStride
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
