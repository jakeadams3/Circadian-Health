//
//  SleepGoalView.swift
//  Circadian Health
//
//  Created by Jake Adams on 12/12/23.
//

import SwiftUI

struct SleepGoalView: View {
    @Binding var showResults: Bool
    @Binding var sleepGoal: Int

    var viewModel: MainInterfaceViewModel

    private var sleepGoalTimeInterval: Binding<TimeInterval> {
        Binding<TimeInterval>(
            get: { TimeInterval(self.sleepGoal) },
            set: {
                self.sleepGoal = Int($0)
                print("Updated sleep goal in View: \(self.sleepGoal) seconds")  // Debugging line
            }
        )
    }

    var body: some View {
        VStack {
            Text("What is your target sleep goal per night?")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()

            viewModel.durationPicker(selection: Binding<TimeInterval>(
                        get: { viewModel.sleepGoal },
                        set: { viewModel.sleepGoal = $0 }
                    ))
                    .frame(maxWidth: .infinity)

            Button(action: {
                withAnimation {
                    viewModel.saveData() // Save data when transitioning to the results
                    print("Selected sleep goal: \(viewModel.sleepGoal) hours")  // Use viewModel.sleepGoal
                    showResults = true
                }
            }) {
                Text("Calculate")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
    }
}
