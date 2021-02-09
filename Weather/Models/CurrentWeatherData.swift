//
//  CurrentWeather.swift
//  Weather
//
//  Created by Bobrovko Ilya on 26.01.2021.
//

import Foundation

struct CurrentWeatherData: Codable {
    let weatherIcon: [WeatherIcon]
    let temperature: Temperature
    let locationName: String
    
    enum CodingKeys: String, CodingKey {
        case weatherIcon = "weather"
        case temperature = "main"
        case locationName = "name"
    }
}

struct Temperature: Codable {
    let current: Double
    let min: Double
    let max: Double
    
    enum CodingKeys: String, CodingKey {
        case current = "temp"
        case min = "temp_min"
        case max = "temp_max"
    }
}

struct WeatherIcon: Codable {
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case id = "icon"
    }
}
