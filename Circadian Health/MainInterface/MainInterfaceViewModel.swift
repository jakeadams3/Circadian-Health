//
//  MainInterfaceViewModel.swift
//  Circadian Health
//
//  Created by Jake Adams on 12/9/23.
//

import Foundation
import SwiftUI

class MainInterfaceViewModel: ObservableObject {
    @Published var wakingTimes: Date? {
            didSet {
                // Save to UserDefaults whenever wakingTimes changes
                if let encoded = try? JSONEncoder().encode(wakingTimes) {
                    UserDefaults.standard.set(encoded, forKey: "wakingTimes")
                }
            }
        }
    
    @Published var sleepGoal = TimeInterval(UserDefaults.standard.double(forKey: "sleepGoal")) {
        didSet {
            UserDefaults.standard.set(sleepGoal, forKey: "sleepGoal")
        }
    }
    @Published var currentIndex = 0 {
        didSet {
            print("currentIndex updated to: \(currentIndex)")
            // Add any additional actions you want to perform when currentIndex changes
        }
    }
    @Published var showResults: Bool
    @Published var navigationTag: Int? = nil // Declare navigationTag here
    @Published var logWakeUpScreen: Bool = false
    @Published var showDetails = false
    
    @Published var newDesiredWakeUpTime: Date = UserDefaults.standard.object(forKey: "newDesiredWakeUpTime") as? Date ?? Date() {
        didSet {
            UserDefaults.standard.set(0, forKey: "morningNotificationCount")
            UserDefaults.standard.set(newDesiredWakeUpTime, forKey: "newDesiredWakeUpTime")
            updateScheduleNotifications()
        }
    }
    
    @Published var newSleepStartTime: Date = UserDefaults.standard.object(forKey: "newSleepStartTime") as? Date ?? Date() {
        didSet {
            UserDefaults.standard.set(0, forKey: "nightNotificationCount")
            UserDefaults.standard.set(newSleepStartTime, forKey: "newSleepStartTime")
            updateScheduleNotifications()
        }
    }
    @Published var isFirstTime: Bool = UserDefaults.standard.object(forKey: "isFirstTime") as? Bool ?? true
    @Published  var showingAlert = false

    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
        // Check if wakingTimes has valid data
        if let data = UserDefaults.standard.data(forKey: "wakingTimes"),
           let savedWakingTime = try? JSONDecoder().decode(Date.self, from: data) {
            wakingTimes = savedWakingTime
            // Only show results if there's valid waking time data
            showResults = true
        } else {
            // Set default date value to 8 AM if no saved value and do not show results
            let calendar = Calendar.current
            wakingTimes = calendar.date(bySettingHour: 8, minute: 0, second: 0, of: Date())
            showResults = false
        }
        
        // Initialize currentIndex
        currentIndex = showResults ? 1 : 0
        
        if UserDefaults.standard.object(forKey: "sleepGoal") != nil {
                    sleepGoal = UserDefaults.standard.double(forKey: "sleepGoal")
                } else {
                    // Set default sleep goal to 8 hours (in seconds)
                    sleepGoal = 8 * 3600
                }

        if UserDefaults.standard.object(forKey: "sleepStartTime") != nil {
            updateScheduleNotifications()
        }
    }

    func updateScheduleNotifications() {
        // First, remove all the previous notifications
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        // Then, reschedule them with the new times
        scheduleNotification("Time to get some light!☀️", startDate: getLightStart)
        scheduleNotification("Time to start reducing your light intake!🌒", startDate: avoidLightStart)
        
        // Get the new desired wake up time and sleep start time from UserDefaults
        if let newDesiredWakeUpTime = UserDefaults.standard.object(forKey: "newDesiredWakeUpTime") as? Date,
           let newSleepStartTime = UserDefaults.standard.object(forKey: "newSleepStartTime") as? Date {
            
            let morningNotificationCount = UserDefaults.standard.integer(forKey: "morningNotificationCount")
            let nightNotificationCount = UserDefaults.standard.integer(forKey: "nightNotificationCount")
            
            // Schedule additional notifications if they have been fired less than 3 times
            if morningNotificationCount < 3 {
                scheduleNotification("Morning! Get some bright light in the next 30 minutes to shift your Circadian Rhythm!☀️", startDate: newDesiredWakeUpTime, countKey: "morningNotificationCount")
            }
            
            if nightNotificationCount < 3 {
                scheduleNotification("Get to bed early tonight to shift your Circadian Rhythm!😴", startDate: newSleepStartTime, countKey: "nightNotificationCount", saveDateKey: "shiftCircadianRhythmDate")
            }
        }
        
        // Schedule sleep notification only if "shiftCircadianRhythmDate" does not exist or is not today
        let shiftCircadianRhythmDate = UserDefaults.standard.object(forKey: "shiftCircadianRhythmDate") as? Date
        if shiftCircadianRhythmDate == nil || !Calendar.current.isDate(shiftCircadianRhythmDate!, inSameDayAs: Date()) {
            scheduleNotification("Time to get some sleep!😴", startDate: sleepStart)
        }
    }

    func scheduleNotification(_ intervalName: String, startDate: Date, countKey: String? = nil, saveDateKey: String? = nil) {
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = "Circadian Health"
        content.body = intervalName
        content.categoryIdentifier = "alarm"
        content.sound = .default

        let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: startDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        center.add(request)
        
        if let countKey = countKey {
            let count = UserDefaults.standard.integer(forKey: countKey)
            UserDefaults.standard.set(count + 1, forKey: countKey)
        }
        
        if let saveDateKey = saveDateKey {
            UserDefaults.standard.set(Date(), forKey: saveDateKey)
        }
    }

    
    var averageWakingTime: Date? {
            return wakingTimes
        }
    
     var temperatureMinimum: Date {
        subtractHours(from: averageWakingTime ?? Date(), hours: 2)
    }
    
     var temperatureMaximum: Date {
        addHours(to: temperatureMinimum, hours: 14)
    }
    
     var getLightStart: Date {
        if let getLightStartTime = UserDefaults.standard.object(forKey: "getLightStartTime") as? Date {
            return getLightStartTime
        } else {
            return addHours(to: temperatureMinimum, hours: 2)
        }
    }
    
     var getLightEnd: Date {
        addHours(to: temperatureMinimum, hours: 6)
    }
    
     var deadzoneStart: Date {
        getLightEnd
    }
    
     var avoidLightStart: Date {
        if let avoidLightStartTime = UserDefaults.standard.object(forKey: "avoidLightStartTime") as? Date {
            return avoidLightStartTime
        } else {
            return temperatureMaximum
        }
    }
    
     var avoidLightEnd: Date {
        sleepStart
    }
    
     var sleepStart: Date {
        if let sleepStartTime = UserDefaults.standard.object(forKey: "sleepStartTime") as? Date {
            return sleepStartTime
        } else {
            return subtractHours(from: averageWakingTime ?? Date(), hours: Int(sleepGoal / 3600))
        }
    }
    
    var sleepEnd: Date {
        averageWakingTime ?? Date() // Fallback to current date if averageWakingTime is nil
    }
    
    func subtractHours(from time: Date, hours: Int) -> Date {
        Calendar.current.date(byAdding: .hour, value: -hours, to: time) ?? time
    }
    
    func addHours(to time: Date, hours: Int) -> Date {
        Calendar.current.date(byAdding: .hour, value: hours, to: time) ?? time
    }
    
    func formatTime(_ time: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: time)
    }
    
    var twoDaysAgo: String {
        let date = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
    
    

    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "wakingTimes") {
            if let decoded = try? JSONDecoder().decode(Date.self, from: data) {
                wakingTimes = decoded
                showResults = true // showResults can be true if a wakingTime is successfully decoded
            }
        }

        // Load sleepGoal
        sleepGoal = UserDefaults.standard.double(forKey: "sleepGoal")
        if sleepGoal == 0 {
            sleepGoal = TimeInterval(8 * 60 * 60) // Default to 8 hours if not set
        }
    }

    func saveData() {
            if let encoded = try? JSONEncoder().encode(wakingTimes) {
                UserDefaults.standard.set(encoded, forKey: "wakingTimes")
                // Debugging print statement
                print("Saving wakingTimes: \(String(describing: wakingTimes))")
            }

        // Save sleepGoal
        UserDefaults.standard.set(sleepGoal, forKey: "sleepGoal")
            print("Saving sleepGoal in ViewModel: \(sleepGoal)")  // Debugging line

        // Update the notifications
        updateScheduleNotifications()
        self.showResults = true
    }
    
    @ViewBuilder
    func datePicker(selection: Binding<Date>) -> some View {
        #if os(iOS)
        HStack {
            Spacer()
            DatePicker("", selection: selection, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .datePickerStyle(WheelDatePickerStyle()).frame(maxWidth: .infinity)
                .background(Color.white)
                .accentColor(.white)
            Spacer()
        }
        #else
        HStack {
            Spacer()
            DatePicker("", selection: selection, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .datePickerStyle(GraphicalDatePickerStyle()).frame(maxWidth: .infinity)
                .background(Color.clear)
                .accentColor(.white)
            Spacer()
        }
        #endif
    }

    @ViewBuilder
    func durationPicker(selection: Binding<TimeInterval>) -> some View {
        #if os(iOS)
        HStack {
            Spacer()
            Picker("", selection: selection) {
                ForEach(6..<11) { hours in
                    Text("\(hours) hours")
                        .tag(TimeInterval(hours * 60 * 60))
                }
            }
            .labelsHidden()
            .pickerStyle(WheelPickerStyle())
            .background(Color.white)
            .accentColor(.white)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        #else
        HStack {
            Spacer()
            Picker("", selection: selection) {
                ForEach(6..<11) { hours in
                    Text("\(hours) hours")
                        .tag(TimeInterval(hours * 60 * 60))
                }
            }
            .labelsHidden()
            .pickerStyle(MenuPickerStyle())
            .background(Color.clear)
            .accentColor(.white)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        #endif
    }
}
