//
//  RepMaxList.swift
//  Maxtimator
//
//  Created by Bear on 5/21/24.
//

import SwiftUI

// MARK: - List view of all max rep estimates
struct RepMaxList: View {
    // DataMgr to load and process the data for listing.
    var exerciseMaxMgr : ExerciseMaxMgr
    
    var body: some View {
        NavigationView {
            List {
                // exercise names are not sorted
                ForEach(Array<String>(exerciseMaxMgr.nameToMax.keys), id:\.self) { exerciseName in
                    ZStack {
                        ExerciseView(exerciseName: exerciseName,
                                     formatedMaxPR: exerciseMaxMgr.formattedMaxPR(for: exerciseName))
                        
                        // This (below) is above (z level) the ExerciseView (above) so it's tappable but empty
                        // This avoids the disclosure indicator (>)
                        NavigationLink {
                            ChartView(exerciseMaxMgr: exerciseMaxMgr, exerciseName: exerciseName)
                        } label: {
                            EmptyView()
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("") // avoid "Back" text in the back button
        }
        .containerRelativeFrame([.horizontal, .vertical]) // go to the edges
        .background(.black)
        .accentColor(.white)
    }
}
