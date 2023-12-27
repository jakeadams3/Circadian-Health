//
//  LogWakeupTimeView.swift
//  Circadian Health
//
//  Created by Jake Adams on 12/9/23.
//

import SwiftUI

struct LogWakeupTimeView: View {
    @ObservedObject var viewModel = MainInterfaceViewModel()
    @State private var newWakeUpTime = Date()
    @Binding var wakingTimes: [Date]
    @State private var showUpdateSuccessMessage = false
    @State private var showAlreadyLoggedMessage = false
    @State private var lastUpdatedDate: Date? = UserDefaults.standard.object(forKey: "lastUpdatedDate") as? Date

    private func datePicker(selection: Binding<Date>) -> some View {
        DatePicker("", selection: selection, displayedComponents: .hourAndMinute)
            .datePickerStyle(WheelDatePickerStyle())
            .labelsHidden()
            .frame(maxWidth: .infinity)
            .clipped()
    }

    var body: some View {
        ZStack {
            Color(red: 15/255, green: 15/255, blue: 15/255).edgesIgnoringSafeArea(.all)
            VStack {
                Text("Log Your Wakeup Time")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                                    .padding(.bottom)
                Text("Log your wakeup time each day below to have Your Circadian Schedule and notifications be accurate and up to date.")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()

                datePicker(selection: $newWakeUpTime)
                    .background(Color.white)

                Button(action: {
                    let today = Calendar.current.startOfDay(for: Date())
                    if let lastDate = lastUpdatedDate, Calendar.current.isDate(today, inSameDayAs: lastDate) {
                        self.showAlreadyLoggedMessage = true
                    } else {
                        self.wakingTimes.removeFirst()
                        self.wakingTimes.append(newWakeUpTime)

                        // Save wakingTimes to UserDefaults
                        let wakingTimesData = try? JSONEncoder().encode(self.wakingTimes)
                        UserDefaults.standard.set(wakingTimesData, forKey: "wakingTimes")

                        // Update Notifications
                        viewModel.updateScheduleNotifications()

                        self.showUpdateSuccessMessage = true
                        self.lastUpdatedDate = today
                        UserDefaults.standard.set(today, forKey: "lastUpdatedDate")
                    }
                }) {
                    Text("Enter")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top, 50.0)

                if showUpdateSuccessMessage {
                    Text("Circadian Intervals Updated Successfully")
                        .foregroundColor(.green)
                        .transition(.opacity)
                        .animation(.easeInOut)
                }

                if showAlreadyLoggedMessage {
                    Text("You've already logged your wakeup time for today...  check back tomorrow!")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .transition(.opacity)
                        .animation(.easeInOut)
                }

            }
        }
        .environment(\.colorScheme, .light)
    }
}
