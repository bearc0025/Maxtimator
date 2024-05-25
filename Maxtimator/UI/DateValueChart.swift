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
    var calendarScale : Calendar.Component { get }
    var chartStride : Int { get }
    var minVal : Int { get }
    var maxVal : Int { get }
    func date(for dateString : String) -> Date
    func value(for date : String) -> Double
    var sortedDateStrings : [String] { get }
}

// MARK: - Rep max estimate chart UI
struct DateValueChart : View {
    var chartDataSource : DateValueChartDelegate
    
    var body: some View {
        Chart {
            // get the date strings and chart
            ForEach(Array(chartDataSource.sortedDateStrings), id:\.self) { date in
                LineMark(
                    x: .value("Date", chartDataSource.date(for: date)),
                    y: .value("Weight", chartDataSource.value(for: date))
                )
                PointMark(
                    x: .value("Date", chartDataSource.date(for: date)),
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
            let calStride = chartDataSource.chartStride
            AxisMarks(values: .stride(by: calScale,
                                      count: calStride)) { value in
                switch calScale {
                case .day:
                    AxisValueLabel(format: .dateTime.month().day())
                case .month:
                    AxisValueLabel(format: .dateTime.month().year(.twoDigits))
                default:
                    AxisValueLabel(format: .dateTime.month())
                }
            }
        }
        .chartYAxis {
            AxisMarks(values: .automatic(desiredCount: (chartDataSource.maxVal - chartDataSource.minVal) / 25))
        }
        .chartYScale(domain: [chartDataSource.minVal, chartDataSource.maxVal])
    }
    
}
