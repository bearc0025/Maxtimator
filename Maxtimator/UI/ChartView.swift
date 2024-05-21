//
//  ChartView.swift
//  Maxtimator
//
//  Created by Bear on 5/21/24.
//

import SwiftUI

// MARK: - The exercise info and charge UI
struct ChartView : View {
    var dataMgr : DataMgr
    var exerciseName : String
    
    var body: some View {
        // Destination of the list item: same a list item plus chart
        VStack {
            ExerciseView(exerciseName: exerciseName,
                         formatedMaxPR: dataMgr.exerciseMaxMgr.formattedMaxPR(for: exerciseName))
            MaxPRChart(exerciseMax: dataMgr.exerciseMaxMgr.nameToMax[exerciseName]!)
            
            // Bottom third empty
            Spacer()
                .frame(height: UIScreen.main.bounds.height / 3)
        }
        .padding()
    }
}
