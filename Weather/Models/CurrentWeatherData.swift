//
//  CurrentWeather.swift
//  Weather
//
//  Created by Bobrovko Ilya on 26.01.2021.
//

import Foundation

struct CurrentWeatherData: Codable {
    let weather: [Weather]
    let main: Main
    let name: String
}

struct Main: Codable {
    let temp: Double
    let tempMin: Double
    let tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

struct Weather: Codable {
    let id: Int
    let icon: String
}
