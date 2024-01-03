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
            let currentDate = Date()
            let progressAngle = calculateProgressAngle(currentDate: currentDate)
            let lineWidth: CGFloat = 10  // Set the line width

            // Draw the progress ring
            Path { path in
                path.addArc(center: center, radius: outerRadius - lineWidth / 2, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: -90 + progressAngle), clockwise: false)
            }
            .stroke(Color.white, lineWidth: lineWidth)
            .opacity(0.5)

            // Calculate the end point of the perpendicular line on the outer circumference of the progress ring
            let lineOuterEndPoint = CGPoint(x: center.x + cos((-90 + progressAngle).degreesToRadians) * outerRadius,
                                            y: center.y + sin((-90 + progressAngle).degreesToRadians) * outerRadius)
            
            // Calculate the intermediate point (two-thirds towards the center)
            let twoThirdsPoint = CGPoint(x: center.x + (lineOuterEndPoint.x - center.x) * 1 / 3,
                                         y: center.y + (lineOuterEndPoint.y - center.y) * 1 / 3)
            
            // Draw the perpendicular line
            Path { path in
                path.move(to: lineOuterEndPoint)
                path.addLine(to: twoThirdsPoint)
            }
            .stroke(Color.white, lineWidth: 2)
        }
    }

    private func calculateProgressAngle(currentDate: Date) -> Double {
        let timeElapsed = currentDate.timeIntervalSince(getLightStart)
        let progress = (timeElapsed.truncatingRemainder(dividingBy: totalDaySeconds)) / totalDaySeconds
        return progress * 360.0 // Convert progress to angle
    }
}

extension CGFloat {
    var degreesToRadians: CGFloat { self * .pi / 180 }
}
