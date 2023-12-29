//
//  ProgressRingView.swift
//  Circadian Health
//
//  Created by Jake Adams on 12/28/23.
//

import SwiftUI

struct ProgressRingView: View {
    var getLightStart: Date
    let totalDaySeconds: Double = 86400.0 // Total seconds in a day

    var body: some View {
        GeometryReader { geometry in
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let outerRadius = min(geometry.size.width, geometry.size.height) / 2
            let innerRadius = outerRadius * 0.618 // Adjusted to match the inner radius of the pie chart
            let middleRadius = (outerRadius + innerRadius) / 2 // Radius for the progress ring
            let currentDate = Date()
            let progressAngle = calculateProgressAngle(currentDate: currentDate)

            Path { path in
                path.addArc(center: center, radius: middleRadius, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: -90 + progressAngle), clockwise: false)
            }
            .stroke(Color.white, lineWidth: 10) // Adjusted line width for better visibility
            .opacity(0.5)
        }
    }

    private func calculateProgressAngle(currentDate: Date) -> Double {
        let timeElapsed = currentDate.timeIntervalSince(getLightStart)
        let progress = (timeElapsed.truncatingRemainder(dividingBy: totalDaySeconds)) / totalDaySeconds
        return progress * 360.0 // Convert progress to angle
    }
}
