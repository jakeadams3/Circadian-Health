//
//  DateUtils.swift
//  Circadian Health
//
//  Created by Jake Adams on 12/9/23.
//

import SwiftUI

func formatTime(_ time: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "hh:mm a"
    return dateFormatter.string(from: time)
}

func dateToRadians(date: Date) -> CGFloat {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.hour, .minute], from: date)
    let totalMinutes = CGFloat(components.hour!) * 60 + CGFloat(components.minute!)
    return 2 * .pi * totalMinutes / 1440 // Convert to radians (2pi radians / 24 hours / 60 minutes = pi/720 radian per minute)
}

func dateToDegrees(date: Date) -> Double {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.hour, .minute], from: date)
    let totalMinutes = Double(components.hour!) * 60 + Double(components.minute!)
    return totalMinutes / 4 // Convert to degrees (360 degrees / 24 hours / 60 minutes = 1/4 degree per minute)
}

func dateToPosition(date: Date, in size: CGSize, radiusScale: CGFloat = 1) -> CGPoint {
    let midPoint = CGPoint(x: size.width / 2, y: size.height / 2)
    let radius = size.width / 2
    let angle = dateToRadians(date: date)
    let adjustedRadiusScale: CGFloat = 1.5
    return CGPoint(
        x: midPoint.x + (radius * adjustedRadiusScale * cos(angle - .pi / 2)),
        y: midPoint.y + (radius * adjustedRadiusScale * sin(angle - .pi / 2))
    )
}


