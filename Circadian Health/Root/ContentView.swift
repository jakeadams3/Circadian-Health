//
//  ContentView.swift
//  Circadian Health
//
//  Created by Jake Adams on 5/10/23.
//

import SwiftUI
import UserNotifications

@available(iOS 17.0, *)
struct ContentView: View {
    @ObservedObject var viewModel = MainInterfaceViewModel()
    
    var body: some View {
        MainTabView()
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//            .previewDevice("iPhone 14 Pro Max")
//    }
//}
