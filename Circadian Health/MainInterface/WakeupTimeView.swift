//
//  WakeupTimeView.swift
//  Circadian Health
//
//  Created by Jake Adams on 12/11/23.
//

import SwiftUI

struct WakeupTimeView: View {
    @Binding var showResults: Bool
    @Binding var currentIndex: Int
    @Binding var wakingTimes: [Date]

    var viewModel: MainInterfaceViewModel

    private var titleText: String {
        switch currentIndex {
        case 0:
            return "What is your target wakeup time? (This should ideally be within a few hours of sunrise)"
        case 1:
            return "What was your wakeup time yesterday?"
        case 2:
            return "What was your wakeup time today?"
        default:
            return ""
        }
    }

    var body: some View {
        VStack {
            Text(titleText)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()

            viewModel.datePicker(selection: $wakingTimes[currentIndex])
                .frame(maxWidth: .infinity)

            Button(action: {
                withAnimation {
                    viewModel.saveData()
                    // Debugging print statement
                    print("Selected wakeup time for index \(currentIndex): \(wakingTimes[currentIndex])")
                    currentIndex += 1
                }
            }) {
                Text("Next")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .onAppear {
            var calendar = Calendar.current
            calendar.timeZone = TimeZone.current
            var components = calendar.dateComponents([.year, .month, .day], from: Date())
            components.hour = 8
            components.minute = 0
            components.second = 0

            let defaultTime = calendar.date(from: components) ?? Date()

            if wakingTimes.count > currentIndex {
                wakingTimes[currentIndex] = defaultTime
            }
        }
    }
}
