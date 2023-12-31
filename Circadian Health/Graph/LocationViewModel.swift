//
//  LocationViewModel.swift
//  Circadian Health
//
//  Created by Jake Adams on 12/30/23.
//

import Foundation
import CoreLocation
import WeatherKit

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var sunriseTime: Date = Date()
    @Published var sunsetTime: Date = Date()
    private let locationManager = CLLocationManager()
    private let weatherService = WeatherService.shared

    static let shared = LocationViewModel() // Singleton instance

        private override init() {
            super.init()
            locationManager.delegate = self
            requestLocationPermission()
        }

    private func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func fetchCurrentLocation() {
        locationManager.requestLocation()
    }

    private func fetchWeatherData(for location: CLLocation) {
            print("Fetching weather data for location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            Task {
                do {
                    let weather = try await weatherService.weather(for: location)
                    let sunrise = weather.dailyForecast[0].sun.sunrise
                    let sunset = weather.dailyForecast[0].sun.sunset

                    print("Sunrise time: \(sunrise), Sunset time: \(sunset)")

                    DispatchQueue.main.async {
                        self.sunriseTime = sunrise!
                        self.sunsetTime = sunset!
                    }
                } catch {
                    print("Error fetching weather data: \(error)")
                }
            }
        }

    // CLLocationManagerDelegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Current location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            fetchWeatherData(for: location)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined, .restricted, .denied:
            print("Location access denied")
        case .authorizedAlways, .authorizedWhenInUse:
            print("Location access granted")
        @unknown default:
            fatalError()
        }
    }
}
