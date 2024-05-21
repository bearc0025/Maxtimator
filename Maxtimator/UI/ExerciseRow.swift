//
//  ExerciseRow.swift
//  Maxtimator
//
//  Created by Bear on 5/18/24.
//

import SwiftUI

// MARK: - List view UI for a given exercise max
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
