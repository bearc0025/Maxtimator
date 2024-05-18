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

