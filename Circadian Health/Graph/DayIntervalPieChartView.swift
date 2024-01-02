//
//  CustomDayChartView.swift
//  Circadian Health
//
//  Created by Jake Adams on 12/19/23.
//

import SwiftUI
import Charts

@available(iOS 17.0, *)
struct DayIntervalPieChartView: View {
    // Your Date intervals
    var sleepStart: Date
    var sleepEnd: Date
    var temperatureMinimum: Date
    var temperatureMaximum: Date
    var getLightStart: Date
    var getLightEnd: Date
    var deadzoneStart: Date
    var avoidLightStart: Date
    var avoidLightEnd: Date
    
    @ObservedObject var viewModel: MainInterfaceViewModel
    @ObservedObject var locationViewModel = LocationViewModel.shared

    // Calculate percentage of the day, considering intervals that cross midnight
    private func percentageOfTheDay(start: Date, end: Date) -> Double {
        let endAdjusted = (end < start) ? Calendar.current.date(byAdding: .day, value: 1, to: end) ?? end : end
        let totalSeconds = Calendar.current.dateComponents([.second], from: start, to: endAdjusted).second ?? 0
        let percentage = Double(totalSeconds) / 86400.0 * 100
        return percentage
    }
    
    // Determine color based on the interval name
    private func colorForInterval(_ intervalName: String) -> Color {
        switch intervalName {
        case "Get Light: \(viewModel.formatTime(viewModel.getLightStart)) - \(viewModel.formatTime(viewModel.getLightEnd))":
            return .green
        case "Circadian Deadzone: \(viewModel.formatTime(viewModel.deadzoneStart)) - \(viewModel.formatTime(viewModel.avoidLightStart))":
            return .orange
        case "Avoid Light: \(viewModel.formatTime(viewModel.avoidLightStart)) - \(viewModel.formatTime(viewModel.avoidLightEnd))":
            return .red
        case "Sleep: \(viewModel.formatTime(viewModel.sleepStart)) - \(viewModel.formatTime(viewModel.sleepEnd))":
            return .blue
        default:
            return .gray // Default color
        }
    }
    
    // Data for the chart
    private var dayIntervals: [DayInterval] {
        return [
            DayInterval(name: "Get Light: \(viewModel.formatTime(viewModel.getLightStart)) - \(viewModel.formatTime(viewModel.getLightEnd))", value: percentageOfTheDay(start: getLightStart, end: getLightEnd)),
            DayInterval(name: "Circadian Deadzone: \(viewModel.formatTime(viewModel.deadzoneStart)) - \(viewModel.formatTime(viewModel.avoidLightStart))", value: percentageOfTheDay(start: deadzoneStart, end: avoidLightStart)),
            DayInterval(name: "Avoid Light: \(viewModel.formatTime(viewModel.avoidLightStart)) - \(viewModel.formatTime(viewModel.avoidLightEnd))", value: percentageOfTheDay(start: avoidLightStart, end: avoidLightEnd)),
            DayInterval(name: "Sleep: \(viewModel.formatTime(viewModel.sleepStart)) - \(viewModel.formatTime(viewModel.sleepEnd))", value: percentageOfTheDay(start: sleepStart, end: sleepEnd))
        ]
    }
    
    private func calculateDayNightPercentages() -> (day: Double, night: Double) {
            let sunrise = locationViewModel.sunriseTime
            let sunset = locationViewModel.sunsetTime
            let dayDuration = Calendar.current.dateComponents([.second], from: sunrise, to: sunset).second ?? 0
            let nightDuration = 86400 - dayDuration // Total seconds in a day minus day duration
            
            print("Day duration: \(dayDuration) seconds, Night duration: \(nightDuration) seconds")

            let dayPercentage = Double(dayDuration) / 86400.0 * 100
            let nightPercentage = Double(nightDuration) / 86400.0 * 100

            print("Day percentage: \(dayPercentage)%, Night percentage: \(nightPercentage)%")
            
            return (day: dayPercentage, night: nightPercentage)
        }

        // Update innerDayIntervals to use calculated percentages
        private var innerDayIntervals: [InnerDayInterval] {
            let percentages = calculateDayNightPercentages()
            return [
                InnerDayInterval(color: .yellow, value: percentages.day),
                InnerDayInterval(color: .indigo, value: percentages.night)
            ]
        }
    
    private func startAngle(of index: Int) -> Angle {
            var cumulativePercentage = 0.0
            for i in 0..<index {
                cumulativePercentage += dayIntervals[i].value
            }
            let degrees = cumulativePercentage / 100.0 * 360.0 - 90 // Subtracting 90 degrees here
            return Angle(degrees: degrees)
        }
    
    private func timeForTickMark(at index: Int) -> Date {
        let totalSecondsInDay = 86400.0
        var cumulativeSeconds = 0.0
        for i in 0..<index {
            cumulativeSeconds += dayIntervals[i].value / 100.0 * totalSecondsInDay
        }
        // Round to the nearest whole number to avoid rounding errors
        let roundedCumulativeSeconds = round(cumulativeSeconds)
        return Calendar.current.date(byAdding: .second, value: Int(roundedCumulativeSeconds), to: getLightStart) ?? getLightStart
    }
    
    private func rotationAngleForGetLightStart() -> Double {
        let totalSecondsInDay = 86400.0

        // Calculate the time interval between getLightStart and sunriseTime
        let secondsInterval: Int
        if getLightStart > locationViewModel.sunriseTime {
            // getLightStart is after sunrise
            secondsInterval = Calendar.current.dateComponents([.second], from: getLightStart, to: locationViewModel.sunriseTime).second ?? 0
        } else {
            // getLightStart is before sunrise, calculate the time remaining in the day after sunrise plus the time from midnight to getLightStart
            let secondsAfterSunriseToEndOfDay = Calendar.current.dateComponents([.second], from: Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: 1, to: getLightStart)!), to: locationViewModel.sunriseTime).second ?? 0
            let secondsFromMidnightToGetLightStart = Calendar.current.dateComponents([.second], from: getLightStart, to: Calendar.current.startOfDay(for: getLightStart)).second ?? 0
            secondsInterval = secondsAfterSunriseToEndOfDay + secondsFromMidnightToGetLightStart
        }

        let percentageOfDay = Double(secondsInterval) / totalSecondsInDay
        print("\(percentageOfDay)")
        let rotationAngle = percentageOfDay * 360.0
        return rotationAngle
    }

    var body: some View {
        VStack {
            // Use GeometryReader to adapt to various screen sizes
            GeometryReader { geometry in
                ZStack {
                    
                    ZStack {
                        Chart(innerDayIntervals, id: \.id) { interval in
                            SectorMark(
                                angle: .value("Value", interval.value),
                                innerRadius: .ratio(0.58),
                                outerRadius: .ratio(0.8)
                            )
                            .foregroundStyle(interval.color)
                        }
                        .aspectRatio(1, contentMode: .fit)
                        .rotationEffect(Angle(degrees: self.rotationAngleForGetLightStart()))
                    }
                    .frame(width: geometry.size.width * 0.62, height: geometry.size.height * 0.62)
                    
                    // ZStack for the pie chart and tick marks
                    ZStack {
                        Chart(dayIntervals, id: \.name) { interval in
                            SectorMark(
                                angle: .value("Value", interval.value),
                                innerRadius: .ratio(0.618)
                            )
                            .foregroundStyle(colorForInterval(interval.name))
                        }
                        .aspectRatio(1, contentMode: .fit)

//                        ForEach(0..<dayIntervals.count, id: \.self) { index in
//                            TickMark(angle: self.startAngle(of: index))
//                        }
                        
                        ProgressRingView(getLightStart: getLightStart)
                    }
                    .frame(width: geometry.size.width * 0.62, height: geometry.size.height * 0.62) // Scale down the graph and tick marks by 0.75

                    // Separate ZStack for the time labels
                    ZStack {
                        ForEach(0..<dayIntervals.count, id: \.self) { index in
                            TimeLabel(angle: self.startAngle(of: index), time: self.timeForTickMark(at: index), viewModel: viewModel)
                        }
                    }
                    .frame(width: geometry.size.width * 0.75, height: geometry.size.height * 0.75)
                    
                    VStack {
                        Text("You").bold()
                        Text("Are").bold()
                        Text("Here").bold()
                    }
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .frame(width: 70, height: 70)
                    .background(Color.black)
                    .clipShape(Circle()) // Clip the frame into a circle
                    .padding(2)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
            .padding(.horizontal)
            .padding(.bottom, 13)


            // Custom Legends
            VStack(alignment: .center) {
                ForEach(dayIntervals, id: \.name) { interval in
                    HStack {
                        ColorSwatch(color: colorForInterval(interval.name))

                        // Separate the label into two parts: the colored part and the white part.
                        let intervalParts = interval.name.components(separatedBy: ": ")
                        if intervalParts.count == 2 {
                            Text(intervalParts[0] + ":")
                                .foregroundColor(colorForInterval(interval.name)) // Colored part

                            Text(" " + intervalParts[1])
                                .foregroundColor(.white) // Remaining part stays white
                        } else {
                            Text(interval.name)
                                .foregroundColor(.white) // Fallback in case of unexpected format
                        }
                    }
                }
            }
            Spacer(minLength: 50)
        }
        .onAppear {
            // Fetch current location when the view appears
            locationViewModel.fetchCurrentLocation()
        }
    }
}

struct DayInterval: Identifiable {
    let id = UUID()
    var name: String
    var value: Double
}

// Color swatch for custom legend
struct ColorSwatch: View {
    var color: Color
    
    var body: some View {
        color
            .frame(width: 20, height: 20)
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.black, lineWidth: 1)
            )
    }
}

struct TickMark: View {
    let angle: Angle

    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                let radius = min(geometry.size.width, geometry.size.height) / 2
                let tickStart = CGPoint(x: center.x + Darwin.cos(angle.radians) * radius,
                                        y: center.y + Darwin.sin(angle.radians) * radius)
                let tickEnd = CGPoint(x: center.x + Darwin.cos(angle.radians) * (radius - 19),
                                      y: center.y + Darwin.sin(angle.radians) * (radius - 19))
                path.move(to: tickStart)
                path.addLine(to: tickEnd)
            }
            .stroke(Color.white, lineWidth: 1)
        }
    }
}

struct TimeLabel: View {
    let angle: Angle
    let time: Date
    var viewModel: MainInterfaceViewModel

    var body: some View {
        GeometryReader { geometry in
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let radius = min(geometry.size.width, geometry.size.height) / 2 + 20 // Adjust as needed
            let labelPosition = CGPoint(x: center.x + Darwin.cos(angle.radians) * radius,
                                        y: center.y + Darwin.sin(angle.radians) * radius)

            Text(viewModel.formatTime(time))
                .position(labelPosition)
                .foregroundColor(.white)
        }
    }
}

struct InnerDayInterval: Identifiable {
    let id = UUID()
    var color: Color
    var value: Double
}
