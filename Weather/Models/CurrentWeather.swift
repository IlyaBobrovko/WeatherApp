//
//  CurrentWeather.swift
//  Weather
//
//  Created by Bobrovko Ilya on 26.01.2021.
//

import Foundation

struct CurrentWeather {
    
    let locationName: String
    
    private let currentTemperature: Double
    var currentTempetatureString: String {
        return String(Int(currentTemperature.rounded()))
    }
    
    private let minTemperature: Double
    var minTemperatureString: String {
        return String(format: "%.0f", minTemperature)
    }
    
    private let maxTemperature: Double
    var maxTemperatureString: String {
        return String(format: "%.0f", maxTemperature)
    }
    
    let weatherIcon: String
    static let weatherIcons: [String: String] = [
        "01d" : "sun.max.fill",
        "01n" : "moon.fill",
        "02d" : "cloud.sun.fill",
        "02n" : "cloud.moon.fill",
        "03d" : "cloud.fill",
        "03n" : "cloud.fill",
        "04d" : "cloud.fill",
        "04n" : "cloud.fill",
        "09d" : "cloud.drizzle.fill",
        "09n" : "cloud.drizzle.fill",
        "10d" : "cloud.heavyrain.fill",
        "10n" : "cloud.heavyrain.fill",
        "11d" : "cloud.bolt.rain.fill",
        "11n" : "cloud.bolt.rain.fill",
        "13d" : "snow",
        "13n" : "snow",
        "50d" : "cloud.fog.fill",
        "50n" : "cloud.fog.fill"
    ]
    
    var weatherImageName: String {
        return CurrentWeather.weatherIcons[weatherIcon] ?? "exclamationmark.icloud.fill"
    }
    
    init(data: CurrentWeatherData) {
        locationName = data.locationName
        currentTemperature = data.temperature.current
        minTemperature = data.temperature.min
        maxTemperature = data.temperature.max
        weatherIcon = data.weatherIcon.first?.id ?? "exclamationmark.icloud.fill"
    }
}
