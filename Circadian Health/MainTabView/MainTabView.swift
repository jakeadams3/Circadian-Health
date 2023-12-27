//
//  MainTabView.swift
//  Circadian Health
//
//  Created by Jake Adams on 12/23/23.
//

import SwiftUI

@available(iOS 17.0, *)
struct MainTabView: View {
    // Assuming that these bindings are necessary for MainInterfaceView
    @State private var showResults = false
    @State private var currentIndex = 0
    @State private var wakingTimes: [Date] = []
    @State private var sleepGoal = 0
    @ObservedObject var viewModel = MainInterfaceViewModel()
    @State private var selectedIndex = 0
    
    init() {
            // Customize the appearance of the tab bar
            let appearance = UITabBarAppearance()
            appearance.backgroundColor = UIColor.black

            // Customize the unselected tab item appearance
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor.white
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]

            // Set the appearance for both standard and compact sizes
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }

    var body: some View {
        TabView(selection: $selectedIndex) {
            let sleepGoalHours = Int(round(viewModel.sleepGoal / 3600))
            
            let wakingTimesArray = Binding<[Date]>(
                get: { viewModel.wakingTimes.map { [$0] } ?? [] },
                set: { viewModel.wakingTimes = $0.first }
            )

            MainInterfaceView(showResults: $viewModel.showResults,
                              currentIndex: $viewModel.currentIndex,
                              wakingTimes: wakingTimesArray,
                              sleepGoal: .constant(sleepGoalHours))
                .tabItem {
                    Label("Circadian Schedule", systemImage: "sun.max")
                }
                .tag(0)

            TemperatureView()
                .tabItem {
                    Label("Body Temperature", systemImage: "thermometer.sun")
                }
                .tag(1)
            
            CircadianInfoView() // Replace with your actual CircadianInfoView and its required parameters
                .tabItem {
                    Label("Info", systemImage: "info.circle")
                }
                .tag(2)
            
        }
        .accentColor(.blue)
    }
}
