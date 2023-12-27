//
//  TemperatureView.swift
//  Circadian Health
//
//  Created by Jake Adams on 12/24/23.
//

import SwiftUI

struct TemperatureView: View {
    @ObservedObject var viewModel = MainInterfaceViewModel()
    
    var body: some View {
        ZStack {
            Color(.black).edgesIgnoringSafeArea(.top)
            VStack {
                Text("Your Temperature Minimum occurs at: \(viewModel.formatTime(viewModel.temperatureMinimum))")
                    .foregroundColor(.white)
                Text("Your Temperature Maximum occurs at: \(viewModel.formatTime(viewModel.temperatureMaximum))")
                    .foregroundColor(.white)
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    TemperatureView()
}
