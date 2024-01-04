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

    @ObservedObject var locationViewModel = LocationViewModel.shared
    var viewModel: MainInterfaceViewModel

    private var titleText: String {
        switch currentIndex {
        case 1:
            return "Yesterday's Wakeup Time"
        case 2:
            return "Today's Wakeup Time"
        default:
            return ""
        }
    }

    // Computed property for sunrise time text
    private var sunriseTimeText: String {
        locationViewModel.hasLocationAccess ? viewModel.formatTime(locationViewModel.sunriseTime) : "N/A"
    }

    var body: some View {
        VStack(spacing: 30) {
            if currentIndex == 0 {
                Text("Enter your typical or target wakeup time:")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                // Updated to use sunriseTimeText
                Text("The closer to sunrise (\(sunriseTimeText)), the better.")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            } else {
                Text(titleText)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
            }

            viewModel.datePicker(selection: $wakingTimes[currentIndex])
                .frame(maxWidth: .infinity)
                .labelsHidden() // Hide the default labels for a cleaner look

            Button(action: {
                withAnimation {
                    viewModel.saveData()
                    currentIndex += 1
                }
            }) {
                Text("Next")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.yellow]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
        }
        .padding()
        .onAppear {
            refreshWakeupView()
        }
        .onChange(of: locationViewModel.hasLocationAccess) { _ in
            refreshWakeupView()
        }
    }

    // Function to refresh the wakeup view
    private func refreshWakeupView() {
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

        if locationViewModel.hasLocationAccess {
            locationViewModel.fetchCurrentLocation()
        }
    }
}
