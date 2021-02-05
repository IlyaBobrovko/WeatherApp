//
//  CurrentWeather.swift
//  Weather
//
//  Created by Bobrovko Ilya on 26.01.2021.
//

import Foundation

struct CurrentWeather {
    
    let cityName: String
    
    let currentTemperature: Double
    var currentTempetatureString: String {
        return String(Int(currentTemperature.rounded()))
    }
    
    let minTemperature: Double
    var minTemperatureString: String {
        return String(format: "%.0f", minTemperature)
    }
    
    let maxTemperature: Double
    var maxTemperatureString: String {
        return String(format: "%.0f", maxTemperature)
    }
    
    let weatherIcon: String
    let weatherIcons: [String: String] = [
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
        return weatherIcons[weatherIcon] ?? "exclamationmark.icloud.fill"
    }
    
    init(currentWetherData: CurrentWeatherData) {
        cityName = currentWetherData.name
        currentTemperature = currentWetherData.main.temp
        minTemperature = currentWetherData.main.tempMin
        maxTemperature = currentWetherData.main.tempMax
        weatherIcon = currentWetherData.weather.first?.icon ?? "exclamationmark.icloud.fill"
    }
}
