//
//  RepMaxList.swift
//  Maxtimator
//
//  Created by Bear on 5/21/24.
//

import SwiftUI

struct RepMaxList: View {
    // DataMgr to load and process the data for listing.
    @StateObject var dataMgr = DataMgr(dataLoader: DataFileLoader(),
                                       repMaxEstimator: BrzyckiRepMaxEstimator())
    
    var body: some View {
        NavigationView {
            List {
                // exercise names are not sorted
                ForEach(Array<String>(dataMgr.exerciseMaxMgr.nameToMax.keys), id:\.self) { exerciseName in
                    ZStack {
                        ExerciseView(exerciseName: exerciseName,
                                     formatedMaxPR: dataMgr.exerciseMaxMgr.formattedMaxPR(for: exerciseName))
                        
                        // This (below) is above (z level) the ExerciseView (above) so it's tappable but empty
                        // This avoids the disclosure indicator (>)
                        NavigationLink {
                            ChartView(dataMgr: dataMgr, exerciseName: exerciseName)
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
