//
//  NetworkWeatherManager.swift
//  Weather
//
//  Created by Bobrovko Ilya on 26.01.2021.
//

import Foundation
import CoreLocation

protocol NetworkWeatherManagerDelegate {
    func updateWeatherData(for weather: CurrentWeather)
    func activateLoadingIndicator()
    func deactivateLoadingIndicator()
    func presentErrorAlert(errorType: ErrorType)
}

class NetworkWeatherManager {
    
    private var networkManager = NetworkManager()
    var delegate: NetworkWeatherManagerDelegate?
    
    enum WeatherRequestType {
        case city(name: String)
        case coordinate(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    }
    
    private func getURL(for type: WeatherRequestType) -> String {
        switch type {
        case .city(let name):
            return "\(urlPath)?units=metric&q=\(name)&appid=\(apiKey)"
        case .coordinate(let latitude, let longitude):
            return "\(urlPath)?units=metric&lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"
        }
    }

    func fetchCurrentWeather(requestType: WeatherRequestType) {
        
        let urlString = getURL(for: requestType)
        
        print(urlString)     // delete this
        delegate?.activateLoadingIndicator()
        DispatchQueue.global(qos: .userInteractive).async {
        
            guard self.networkManager.isInternetConntected() else {
                DispatchQueue.main.async { self.delegate?.presentErrorAlert(errorType: .networkError) }
                return
            }

            guard let url = URL(string: urlString), let data = try? Data(contentsOf: url) else {
                DispatchQueue.main.async { self.delegate?.presentErrorAlert(errorType: .ivalidLocationError) }
                return
            }
            
            guard let jsonData = try? JSONDecoder().decode(CurrentWeatherData.self, from: data) else { return }
       
            print("\(jsonData.locationName) \(jsonData.weatherIcon.first?.id ?? "unknown") icon\n") // delete

            DispatchQueue.main.async {
                self.delegate?.updateWeatherData(for: CurrentWeather(data: jsonData))
            }
        }
    }
}
