//
//  ContentView.swift
//  Maxtimator
//
//  Created by Bear on 5/17/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(ExerciseMaxMgr.self) var exMgr : ExerciseMaxMgr
    
    var body: some View {
        RepMaxList(exerciseMaxMgr: exMgr)
    }
}

#Preview {
    ContentView()
        .environment(\.colorScheme, .dark)
        .environment(ExerciseMaxMgr(dataLoader: DataFileLoader(),
                                    maxEstimator: BrzyckiRepMaxEstimator()))
}

