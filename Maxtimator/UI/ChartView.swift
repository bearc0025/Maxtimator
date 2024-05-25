//
//  ChartView.swift
//  Maxtimator
//
//  Created by Bear on 5/21/24.
//

import SwiftUI

// MARK: - The exercise info and charge UI
struct ChartView : View {
    var exerciseMaxMgr : ExerciseMaxMgr
    var exerciseName : String
    
    @State var spacerHeight = 0.0
    
    var chartHeight : CGFloat = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) / 3
    var halfMaxHW : CGFloat { max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) / 2 }

    var body: some View {
        // Destination of the list item: same a list item plus chart
        VStack {
            ExerciseView(exerciseName: exerciseName,
                         formatedMaxPR: exerciseMaxMgr.formattedMaxPR(for: exerciseName))
            
            DateValueChart(chartDataSource: exerciseMaxMgr.nameToMax[exerciseName]!)
                .frame(minHeight: chartHeight)
            
            Spacer()
                .frame(maxHeight: spacerHeight)
        }
        .padding()
        .onAppear(perform: {
            spacerHeight = UIDevice.current.orientation.isLandscape ? 0 : halfMaxHW
        })
        .onReceive(NotificationCenter.Publisher(center: .default, name: UIDevice.orientationDidChangeNotification)) { _ in
            spacerHeight = UIDevice.current.orientation.isLandscape ? 0 : halfMaxHW
        }
    }
}

