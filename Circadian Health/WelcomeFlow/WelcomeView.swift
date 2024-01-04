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
            Color(.black).edgesIgnoringSafeArea(.all)

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

                Text("Ready to discover your Circadian Rhythm and enhance the quality and longevity of your life? Hit Continue to get started!")
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
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.yellow]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
            }
        }
    }
}
