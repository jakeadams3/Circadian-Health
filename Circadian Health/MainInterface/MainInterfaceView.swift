//
//  MainInterfaceView.swift
//  Circadian Health
//
//  Created by Jake Adams on 12/9/23.
//

import SwiftUI

@available(iOS 17.0, *)
struct MainInterfaceView: View {
    @ObservedObject var viewModel = MainInterfaceViewModel()
    @Binding var showResults: Bool
    @Binding var currentIndex: Int
    @Binding var wakingTimes: [Date]
    @Binding var sleepGoal: Int

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.yellow.opacity(1.0), Color.black.opacity(1.0), Color.blue.opacity(1.0)]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) { // Consistent spacing for a cleaner look
                    if !showResults {
                        Spacer()
                        
                        if currentIndex < 1 {
                            WakeupTimeView(showResults: $showResults, currentIndex: $currentIndex, wakingTimes: $wakingTimes, viewModel: viewModel)
                        } else {
                            SleepGoalView(showResults: $showResults, sleepGoal: $sleepGoal, viewModel: viewModel)
                        }
                        
                        Spacer()
                    } else {
                        ResultsView(viewModel: viewModel, showResults: $showResults, currentIndex: $currentIndex)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarColor(backgroundColor: .black, titleColor: .white) // Custom Modifier to change Navigation Bar color
            .onAppear {
                viewModel.loadData()
                viewModel.updateScheduleNotifications()
            }
            .sheet(isPresented: $viewModel.isFirstTime) {
                WelcomeView(isFirstTime: $viewModel.isFirstTime)
                    .interactiveDismissDisabled()
            }
        }
        .environment(\.colorScheme, .light)
    }
}

// A custom view for the results section
@available(iOS 17.0, *)
struct ResultsView: View {
    @ObservedObject var viewModel: MainInterfaceViewModel
    @ObservedObject var locationViewModel = LocationViewModel.shared
    @Binding var showResults: Bool
    @Binding var currentIndex: Int
    
    private func isCurrentTimeWithin(intervalStart: Date, intervalEnd: Date) -> Bool {
            let calendar = Calendar.current
            let now = Date()
            
            // Extract only the hour and minute components
            let nowComponents = calendar.dateComponents([.hour, .minute], from: now)
            let startComponents = calendar.dateComponents([.hour, .minute], from: intervalStart)
            let endComponents = calendar.dateComponents([.hour, .minute], from: intervalEnd)

            // Reconstruct the dates with only hour and minute for accurate comparison
            let nowTime = calendar.date(from: nowComponents)!
            let startTime = calendar.date(from: startComponents)!
            let endTime = calendar.date(from: endComponents)!
            
            if startTime <= endTime {
                // Normal interval (does not cross midnight)
                return nowTime >= startTime && nowTime <= endTime
            } else {
                // Interval crosses midnight
                return nowTime >= startTime || nowTime <= endTime
            }
        }

    private func getCurrentIntervalContent() -> (emoji: String, title: Text) {
        if isCurrentTimeWithin(intervalStart: viewModel.getLightStart, intervalEnd: viewModel.getLightEnd) {
            return ("☀️", Text("Time to get light!").foregroundColor(.green))
        } else if isCurrentTimeWithin(intervalStart: viewModel.deadzoneStart, intervalEnd: viewModel.avoidLightStart) {
            return ("☀️", Text("Deadzone: Viewing light currently has no effect on circadian rhythm").foregroundColor(.orange))
        } else if isCurrentTimeWithin(intervalStart: viewModel.avoidLightStart, intervalEnd: viewModel.avoidLightEnd) {
            return ("🌒", Text("Time to start avoiding light!").foregroundColor(.red))
        } else if isCurrentTimeWithin(intervalStart: viewModel.sleepStart, intervalEnd: viewModel.sleepEnd) {
            return ("🛏", Text("Time to get some sleep!").foregroundColor(.blue))
        } else {
            return ("❓", Text("Check your schedule").foregroundColor(.gray))
        }
    }
    
    var body: some View {
        VStack {
            Text("Your Circadian Schedule")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top)
            
            Spacer().frame(height: 5) // ok last update for now
            
            TabView {
                // First page: DayIntervalPieChartView
                DayIntervalPieChartView(sleepStart: viewModel.sleepStart, sleepEnd: viewModel.sleepEnd, temperatureMinimum: viewModel.temperatureMinimum, temperatureMaximum: viewModel.temperatureMaximum, getLightStart: viewModel.getLightStart, getLightEnd: viewModel.getLightEnd, deadzoneStart: viewModel.deadzoneStart, avoidLightStart: viewModel.avoidLightStart, avoidLightEnd: viewModel.avoidLightEnd, viewModel: viewModel)
                    .frame(width: UIScreen.main.bounds.width)
                
                // Second page: Additional Legends
                VStack(alignment: .center) {
                    let intervalContent = getCurrentIntervalContent()
                    intervalContent.title
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text(intervalContent.emoji)
                        .font(.system(size: 100))
                        .padding()
                    
                    let sunriseTimeText = locationViewModel.hasFetchedTimes ? viewModel.formatTime(locationViewModel.sunriseTime) : "N/A"
                    let sunsetTimeText = locationViewModel.hasFetchedTimes ? viewModel.formatTime(locationViewModel.sunsetTime) : "N/A"
                    
                    Legend(color: .yellow, text: "Daytime today begins at \(sunriseTimeText)")
                    Legend(color: .indigo, text: "Nighttime today begins at \(sunsetTimeText)")
                    Text("Your temperature minimum occurs at \(viewModel.formatTime(viewModel.temperatureMinimum))")
                        .foregroundColor(.white)
                        .padding(.top, 2)
                        .frame(maxWidth: .infinity)
                    Text("Your temperature maximum occurs at \(viewModel.formatTime(viewModel.temperatureMaximum))")
                        .foregroundColor(.white)
                        .padding(.top, 2)
                        .frame(maxWidth: .infinity)
                    
                    Link(" Weather", destination: URL(string: "https://weatherkit.apple.com/legal-attribution.html")!)
                        .padding(.top, 4)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
                .frame(width: UIScreen.main.bounds.width)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            
            UpdateDataButton(viewModel: viewModel, currentIndex: $currentIndex, showResults: $showResults)
                .padding(.bottom)
                .padding(.horizontal)
        }
    }
}

// A custom button view
struct UpdateDataButton: View {
    @ObservedObject var viewModel: MainInterfaceViewModel
    @Binding var currentIndex: Int
    @Binding var showResults: Bool
    
    var body: some View {
        Button(action: {
            viewModel.showingAlert = true
        }) {
            Text("Update Data")
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.yellow]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(8)
        }
        .alert(isPresented: $viewModel.showingAlert) {
            Alert(title: Text("Are you sure you want to reset your data?"),
                  message: Text("This will clear your graph and intervals."),
                  primaryButton: .default(Text("Yes"), action: {
                    UserDefaults.standard.removeObject(forKey: "wakingTimes")
                    UserDefaults.standard.removeObject(forKey: "sleepGoal")
                    UserDefaults.standard.removeObject(forKey: "newDesiredWakeUpTime")
                    currentIndex = 0
                    showResults = false
                  }),
                  secondaryButton: .cancel())
        }
    }
}

// Custom modifier to change Navigation Bar color
struct NavigationBarModifier: ViewModifier {
    var backgroundColor: UIColor
    var titleColor: UIColor

    func body(content: Content) -> some View {
        content
            .onAppear {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = backgroundColor
                appearance.titleTextAttributes = [.foregroundColor: titleColor]
                appearance.largeTitleTextAttributes = [.foregroundColor: titleColor]
                
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().compactAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
                UINavigationBar.appearance().tintColor = titleColor
            }
    }
}

struct Legend: View {
    var color: Color?
    var text: String

    var body: some View {
        HStack {
            if let color = color {
                ColorSwatch(color: color)
            }

            // Combine the label parts into one Text view for proper wrapping
            let textParts = text.components(separatedBy: "at ")
            if textParts.count == 2 {
                Text(textParts[0] + "at ")
                    .foregroundColor(color) +
                Text(textParts[1])
                    .foregroundColor(.white)
            } else {
                Text(text)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
    }
}

extension View {
    func navigationBarColor(backgroundColor: UIColor, titleColor: UIColor) -> some View {
        self.modifier(NavigationBarModifier(backgroundColor: backgroundColor, titleColor: titleColor))
    }
}

//struct MainInterfaceView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainInterfaceView(showResults: .constant(false), currentIndex: .constant(0), wakingTimes: .constant([Date]()), sleepGoal: .constant(8))
//    }
//}
