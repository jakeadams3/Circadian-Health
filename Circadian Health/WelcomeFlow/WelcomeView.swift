//
//  WelcomeView.swift
//  Circadian Health
//
//  Created by Jake Adams on 12/9/23.
//

import SwiftUI

struct WelcomeView: View {
    @Binding var isFirstTime: Bool

    var body: some View {
        ZStack {
            Color(red: 15/255, green: 15/255, blue: 15/255).edgesIgnoringSafeArea(.all)

            VStack {
                Image("sun logo") // The name of the image in your assets
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200) // Adjust to desired size

                Text("Welcome to Circadian Health!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)

                Text("Ready to discover your Circadian Rhythm and enhance the quality and longevity of your life? Hit continue to get started!")
                    .font(.title3)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 20)

                Button(action: {
                    isFirstTime = false
                    UserDefaults.standard.set(false, forKey: "isFirstTime")
                }) {
                    Text("Continue")
                        .font(.title2)
                        .bold()
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
}
