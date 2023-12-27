//
//  CircadianInfoView.swift
//  Circadian Health
//
//  Created by Jake Adams on 12/9/23.
//

import SwiftUI

struct CircadianInfoView: View {
    var body: some View {
        ZStack {
            Color(.black).edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack {
                    Text("What is the Circadian Rhythm?")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 30)

                    Group {
                        Text("Circadian rhythms are physical, mental, and behavioral changes that follow a 24-hour cycle. These natural processes respond primarily to light and dark and affect most living things, including humans, animals, and microbes.")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10)

                        Text("According to the National Institute of General Medical Sciences (NIGMS), nearly every tissue and organ within the body contains their own biological clock.")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10)
                    }
                    
                    Group {
                        Text("All of these individual clocks are controlled by one single master clock in the brain called the Suprachiasmatic Nucleus (SCN), which contains around 20,000 nerve cells and receives input directly from the eyes.")
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10)

                        Text("As the eyes perceive the bright light of day or the darkness of night, the SCN picks up on this information, signaling nearly every cell within the body to act accordingly. Consistent light-viewing patterns, paired with exercise and consistent eating times, keep the Circadian Rhythm in sync with a 24-hour day.")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10)
                        Text("One vital feature of your body's Circadian Rhythm and 24-hour cycle is your temperature minimum and maximum, or in other words the time of day your body temperature is lowest and highest.")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10)
                        Text("A general rule of thumb to follow to optimize your body's internal clock is to avoid light if your temperature is decreasing, and to get light if your temperature is increasing.")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10)
                        Text("The time window in which Circadian clocks are insensitive to light signals is referred to as the 'Circadian Deadzone'. During this period, light has no major effect on one's Circadian Rhythm.")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 30)
                    }
                        
                    Text("Why is Circadian Health so important?")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 30)
                        
                    Group {
                        Text("The Circadian Rhythm plays a massive role in the functioning of many processes within the body such as the regulation of sleep, digestion and metabolism, mental health, and cellular repair.")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10)

                        Text("Poor Circadian health, which can be caused through unhealthy light viewing patterns, irregular sleep schedules, and lack of consistent dieting can be very detrimental and have many adverse effects on physical and mental well-being, as well as decreasing overall lifespan.")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10)
                    }
                    
                    Group {
                        Text("Adverse effects of poor Circadian health include the potential for sleep disorders, metabolic issues, mental health problems, and chronic health conditions.")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10)
                        
                        Text("On the other hand, taking care of one's Circadian health can lead to increased energy levels, improved mental and physical well-being, enhanced cognition, stronger immune function, and an increased lifespan.")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 30)
                    }
                    Group {
                        Text("How can one maintain Circadian Health?")
                            .font(.title2)
                            .foregroundColor(.blue)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 30)
                        
                        Text("Maintaining great Circadian health mainly involves keeping a regular sleep-wake cycle and managing your exposure to light.")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10)
                        Text("Doing so can be a complicated and tedious process, so we made this tool to hopefully make maintaining great Circadian health a tad bit easier.")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10)
                        Text("Our app calculates and provides you with actionable intervals to follow to let you know when to view light, avoid light, and sleep according to your current Circadian Rhythm.")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10)
                        Text("It is strongly recommended that your Circadian Rhythm and thus wakeup time align with sunrise, as sunrise provides the optimal hue for SCN activation.")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10)
                        Text("By entering the sunrise time for your location into our Shift Your Circadian Rhythm page, we'll generate for you a custom wakeup and bedtime schedule to get your Circadian Rhythm aligned with sunrise in just 3 days.")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10)
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    CircadianInfoView()
}
