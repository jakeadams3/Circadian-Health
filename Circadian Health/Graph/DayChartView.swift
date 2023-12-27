//
//  DayChartView.swift
//  Circadian Health
//
//  Created by Jake Adams on 12/11/23.
//

import SwiftUI

struct DayChartView: View {
    var sleepStart: Date
    var sleepEnd: Date
    var temperatureMinimum: Date
    var temperatureMaximum: Date
    var getLightStart: Date
    var getLightEnd: Date
    var deadzoneStart: Date
    var avoidLightStart: Date
    var avoidLightEnd: Date
    var currentTime: Date {
        Date() // Current date/time
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray, lineWidth: 4)

            TimePeriodArcView(start: sleepStart, end: sleepEnd, color: .blue, label: "Sleep")
            TimePeriodArcView(start: getLightStart, end: getLightEnd, color: .green, label: "Get Light")
            TimePeriodArcView(start: deadzoneStart, end: avoidLightStart, color: .yellow, label: "Deadzone")
            TimePeriodArcView(start: avoidLightStart, end: avoidLightEnd, color: .red, label: "Avoid Light")

            // Current Time Marker
            GeometryReader { geometry in
                            Path { path in
                                let midPoint = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                                let fromPoint = CGPoint(x: midPoint.x + (geometry.size.width / 2 * cos(dateToRadians(date: currentTime) - .pi / 2)),
                                                      y: midPoint.y + (geometry.size.width / 2 * sin(dateToRadians(date: currentTime) - .pi / 2)))
                                let toPoint = CGPoint(x: midPoint.x + (geometry.size.width / 4 * 0.75 * cos(dateToRadians(date: currentTime) - .pi / 2)),
                                                      y: midPoint.y + (geometry.size.width / 4 * 0.75 * sin(dateToRadians(date: currentTime) - .pi / 2)))
                                path.move(to: fromPoint)
                                path.addLine(to: toPoint)
                            }
                            .stroke(Color.white, lineWidth: 2)

                            VStack {
                                Text("You").bold()
                                Text("Are").bold()
                                Text("Here").bold()
                            }
                            .foregroundColor(.white)
                            .frame(width: 70, height: 70)
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        }
                    }
                    .frame(width: 200, height: 200)
                }

    // Convert date to radians for use in drawing the current time marker.
    func dateToRadians(date: Date) -> CGFloat {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        let totalMinutes = CGFloat(components.hour!) * 60 + CGFloat(components.minute!)
        return 2 * .pi * totalMinutes / 1440 // Convert to radians (2pi radians / 24 hours / 60 minutes = pi/720 radian per minute)
    }
}
