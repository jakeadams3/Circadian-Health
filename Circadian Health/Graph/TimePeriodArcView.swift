//
//  TimePeriodArcView.swift
//  Circadian Health
//
//  Created by Jake Adams on 12/11/23.
//

import SwiftUI

struct TimePeriodArcView: View {
    var start: Date
    var end: Date
    var color: Color
    var label: String

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Path { path in
                    let midPoint = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    path.addArc(center: midPoint, radius: geometry.size.width / 2, startAngle: .degrees(dateToDegrees(date: start)), endAngle: .degrees(dateToDegrees(date: end)), clockwise: false)
                }
                .stroke(color, lineWidth: 20)
                .rotationEffect(.degrees(-90))

                // Add label at the start of each arc
                Text(formatTime(start))
                    .fontWeight(.bold)
                    .foregroundColor(.white)  // Set the color of the time label to white
                    .position(dateToPosition(date: start, in: geometry.size, radiusScale: 0.7)) // Adjusted scale to 0.7
            }
        }
    }
}
