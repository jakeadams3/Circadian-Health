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
                Color.black.edgesIgnoringSafeArea(.all)

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
            }
        }
        .environment(\.colorScheme, .light)
    }
}

// A custom view for the results section
@available(iOS 17.0, *)
struct ResultsView: View {
    @ObservedObject var viewModel: MainInterfaceViewModel
    @Binding var showResults: Bool
    @Binding var currentIndex: Int
    
    var body: some View {
        VStack {
            Text("Your Circadian Schedule")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top)
            
            Text("Follow these intervals daily for optimal circadian health")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer().frame(height: 60) // ok last update for now
            
            DayIntervalPieChartView(sleepStart: viewModel.sleepStart, sleepEnd: viewModel.sleepEnd, temperatureMinimum: viewModel.temperatureMinimum, temperatureMaximum: viewModel.temperatureMaximum, getLightStart: viewModel.getLightStart, getLightEnd: viewModel.getLightEnd, deadzoneStart: viewModel.deadzoneStart, avoidLightStart: viewModel.avoidLightStart, avoidLightEnd: viewModel.avoidLightEnd, viewModel: viewModel)
                .padding(.top, 10)
            
            UpdateDataButton(viewModel: viewModel, currentIndex: $currentIndex, showResults: $showResults)
                .padding(.bottom, 20)
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
                .background(Color.blue)
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
