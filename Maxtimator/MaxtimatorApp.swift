//
//  MaxtimatorApp.swift
//  Maxtimator
//
//  Created by Bear on 5/17/24.
//

import SwiftUI

@main
struct MaxtimatorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.colorScheme, .dark)
                .environment(ExerciseMaxMgr(dataLoader: DataFileLoader(),
                                            maxEstimator: BrzyckiRepMaxEstimator()))
        }
    }
}
