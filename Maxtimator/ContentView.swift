//
//  ContentView.swift
//  Maxtimator
//
//  Created by Bear on 5/17/24.
//

import SwiftUI
import Charts

struct ContentView: View {
    // DataMgr to load and process the data for listing.
    @StateObject var dataMgr = DataMgr(dataLoader: DataFileLoader(),
                                       repMaxEstimator: BrzyckiRepMaxEstimator())
    var body: some View {
        NavigationView {
            List {
                ForEach(dataMgr.exerciseMaxMgr.nameToMax.keys.sorted(), id:\.self) { exerciseName in
                    ZStack {
                        ExerciseView(exerciseName: exerciseName,
                                     formatedMaxPR: dataMgr.exerciseMaxMgr.formattedMaxPR(for: exerciseName))
                        
                        // This (below) is above the ExerciseView (above) so it's tappable but empty
                        // This avoids the disclosure indicator (>)
                        NavigationLink {
                            // Destination of the list item: same a list item plus chart
                            VStack {
                                ExerciseView(exerciseName: exerciseName,
                                             formatedMaxPR: dataMgr.exerciseMaxMgr.formattedMaxPR(for: exerciseName))
                                MaxPRChart(exerciseMax: dataMgr.exerciseMaxMgr.nameToMax[exerciseName]!)
                                Spacer()
                                    .frame(height: UIScreen.main.bounds.height / 3)
                            }
                            .padding()
                        } label: {
                            // empty/clear
                            EmptyView()
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("    ") // avoid "< Back"
        }
        .containerRelativeFrame([.horizontal, .vertical]) // go to the edges
        .background(.black)
        .accentColor(.white)
    }
}

#Preview {
    ContentView()
        .environment(\.colorScheme, .dark)
}

/// Simple class to process date label strings
class LabelDate {
    var dateFmtr = DateFormatter()
    init() {
        dateFmtr.dateFormat = "MMM dd yyyy"
    }
    func date(for dateString : String) -> Date {
        dateFmtr.date(from: dateString) ?? .now
    }
}

struct MaxPRChart : View {
    var exerciseMax : ExerciseMax
    let labelDate = LabelDate()
    
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

/// List view UI for a given exercise max
struct ExerciseView: View {
    var exerciseName : String
    var formatedMaxPR : String
    var body: some View {
        VStack {
            HStack {
                Text(exerciseName)
                    .fontWeight(.semibold)
                    .font(.title2)
                Spacer()
                Text(formatedMaxPR)
                    .fontWeight(.semibold)
                    .font(.title2)
            }
            HStack {
                Text("One Rep Max • lbs")
                    .fontWeight(.light)
                    .font(.caption)
                    .foregroundStyle(.gray)
                Spacer()
            }
        }
    }
}
