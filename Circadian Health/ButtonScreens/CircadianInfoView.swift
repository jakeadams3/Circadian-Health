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
            LinearGradient(gradient: Gradient(colors: [Color.yellow.opacity(1.0), Color.black.opacity(1.0), Color.blue.opacity(1.0)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack {
                    Text("What is the circadian rhythm?")
                        .font(.title2)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 30)

                    Group {
                        Text("Think of the circadian rhythm as your body's internal clock. It's like a daily schedule that tells your body when to feel sleepy or awake, hungry or full. This rhythm follows a 24-hour cycle and is mainly affected by light and darkness, something all living things, including people, animals, and even tiny microbes, react to.")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10)

                        Text("The National Institute of General Medical Sciences (NIGMS) tells us that almost every part of our body has its own mini-clock. But there's a main clock in our brain, called the Suprachiasmatic Nucleus (SCN), that keeps all these mini-clocks in check. It's made up of about 20,000 nerve cells and gets information directly from our eyes.")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10)
                    }
                    
                    Group {
                        Text("Every cell and organ in your body requires light information to function properly, but since your internal organs are shielded from direct sunlight by your skin and skeletal system, the only way to relay this vital information is through the eyes.")
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10)
                        
                        Text("By exposing your eyes to sunlight at specific times of the day, you effectively communicate this essential light information to the entirety of your body. This is the sole pathway for such crucial light exposure.")
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10)
                        
                        Text("When our eyes see daylight or darkness, the SCN gets the message and tells the rest of our body. If we keep a regular routine with light exposure, exercise, and meal times, our circadian rhythm stays balanced.")
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10)
                        
                        Text("One vital feature of our body's circadian rhythm and 24-hour cycle is the temperature minimum and maximum, or in other words the time of day our body temperature is at its lowest and highest, respectively.")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10)
                        Text("A general rule of thumb to follow to optimize your body's internal clock is to avoid light if your temperature is decreasing, and to get light if your temperature is increasing.")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10)
                        Text("The time window in which Circadian clocks are insensitive to light signals is referred to as the 'Circadian Deadzone'. During this period, light has no major effect on one's circadian rhythm.")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 30)
                    }
                        
                    Text("Why is circadian health so important?")
                        .font(.title2)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 30)
                        
                    Group {
                        Text("The circadian rhythm plays a massive role in the functioning of many processes within the body such as the regulation of sleep, digestion and metabolism, mental health, and cellular repair.")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10)

                        Text("Poor circadian health, which can be caused through unhealthy light viewing patterns, irregular sleep schedules, and lack of consistent dieting can be very detrimental and have many adverse effects on physical and mental well-being, as well as decreasing overall lifespan.")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10)
                    }
                    
                    Group {
                        Text("Adverse effects of poor Circadian health include the potential for sleep disorders, metabolic issues, depression, and chronic health conditions.")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10)
                        
                        Text("On the other hand, taking care of one's circadian health can lead to increased energy levels, improved mental and physical well-being, enhanced cognition, stronger immune function, and an increased lifespan.")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 30)
                    }
                    Group {
                        Text("How can one maintain circadian health?")
                            .font(.title2)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 30)
                        
                        Text("Maintaining great circadian health mainly involves keeping a regular sleep-wake cycle and managing your exposure to light.")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10)
                        Text("Doing so can be a complicated and tedious process, so this tool was created in hopes to make maintaining great circadian health a tad bit easier.")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10)
                        Text("Our app calculates and provides you with actionable intervals to follow regularly to let you know when to view light, avoid light, and sleep in order to optimize and keep you in sync with your circadian rhythm.")
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
