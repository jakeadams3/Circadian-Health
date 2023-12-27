//
//  ShiftCircadianRhythmView.swift
//  Circadian Health
//
//  Created by Jake Adams on 12/9/23.
//

import SwiftUI

struct ShiftCircadianRhythmView: View {
    @ObservedObject var viewModel = MainInterfaceViewModel()
    @Binding var newDesiredWakeUpTime: Date
    @State private var sleepGoal = TimeInterval(8 * 60 * 60) // Default to 8 hours
    @State private var showMessage: Bool
    @State private var newSleepStartTime: Date? = UserDefaults.standard.object(forKey: "newSleepStartTime") as? Date
    @State private var newDesiredWakeUpTimeDisplay: Date? = UserDefaults.standard.object(forKey: "newDesiredWakeUpTime") as? Date
    
    init(newDesiredWakeUpTime: Binding<Date>) {
        self._newDesiredWakeUpTime = newDesiredWakeUpTime
        let show = UserDefaults.standard.object(forKey: "newSleepStartTime") != nil && UserDefaults.standard.object(forKey: "newDesiredWakeUpTime") != nil
        self._showMessage = State(initialValue: show)
    }
    
    var body: some View {
            ZStack {
                Color(red: 15/255, green: 15/255, blue: 15/255).edgesIgnoringSafeArea(.all)
                ScrollView {
                    VStack {
                        Text("Shift Your Circadian Rhythm")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                            .padding(.vertical)
                        
                        Text("Enter your desired wakeup time below. Follow the generated wakeup time and bedtime for 3 days to align your Circadian Rhythm with your desired wakeup time.")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        DatePicker("", selection: $newDesiredWakeUpTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .frame(maxWidth: .infinity)
                            .clipped()
#if os(iOS)
                            .datePickerStyle(WheelDatePickerStyle())
                            .background(Color.white)
#else
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .background(Color.clear)
#endif
                            .accentColor(.white)
                        
                        Button("Enter", action: {
                            let sleepStartTime = Calendar.current.date(byAdding: .second, value: -Int(sleepGoal), to: newDesiredWakeUpTime)!
                            
                            UserDefaults.standard.set(newDesiredWakeUpTime, forKey: "newDesiredWakeUpTime")
                            UserDefaults.standard.set(sleepStartTime, forKey: "newSleepStartTime")
                            
                            viewModel.updateScheduleNotifications()
                            
                            showMessage = true
                            
                            newSleepStartTime = sleepStartTime
                            newDesiredWakeUpTimeDisplay = newDesiredWakeUpTime
                        })
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.top, 50)
                        
                        if showMessage {
                            Text("Success! Your Circadian Schedule will be updated each time you Log Your Wakeup Time.")
                                .foregroundColor(.green)
                                .multilineTextAlignment(.center)
                                .padding()
                            HStack {
                                Text("Bedtime: \(newSleepStartTime != nil ? DateFormatter.localizedString(from: newSleepStartTime!, dateStyle: .none, timeStyle: .short) : "")")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.orange)
                                Spacer()
                                Text("Wakeup: \(newDesiredWakeUpTimeDisplay != nil ? DateFormatter.localizedString(from: newDesiredWakeUpTimeDisplay!, dateStyle: .none, timeStyle: .short) : "")")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                            }
                            .padding()
                        }
                    }
                }
            }
            .environment(\.colorScheme, .light)
        }
    }
