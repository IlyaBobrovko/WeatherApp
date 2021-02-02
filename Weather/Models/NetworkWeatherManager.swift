//
//  NetworkWeatherManager.swift
//  Weather
//
//  Created by Bobrovko Ilya on 26.01.2021.
//

import Foundation
import CoreLocation

class NetworkWeatherManager {
    
    var networkManager = NetworkManager()
    var delegate: NetworkWeatherManagerDelegate?
    
    enum WeatherRequestType {
        case city(name: String)
        case coordinate(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    }

    func fetchCurrentWeather(requestType: WeatherRequestType) {
        
        let urlString: String
        
        switch requestType {
        case .city(let name):
            urlString = "\(urlPath)?units=metric&q=\(name)&appid=\(apiKey)"
        case .coordinate(let latitude, let longitude):
            urlString = "\(urlPath)?units=metric&lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"
        }
       
        print(urlString)     // для отладки
        delegate?.activateIndicator()
        DispatchQueue.global(qos: .userInteractive).async {
        
            guard self.networkManager.isInternetConntected() else {
                DispatchQueue.main.async {
                    self.delegate?.presentErrorAlert(errorType: .networkError)
                    self.delegate?.deactivateIndicator()
                }
                return
            }

            guard let url = URL(string: urlString), let data = try? Data(contentsOf: url) else {
                DispatchQueue.main.async {
                    self.delegate?.presentErrorAlert(errorType: .ivalidLocationError)
                    self.delegate?.deactivateIndicator()
                }
                return
            }
            
            guard let jsonData = try? JSONDecoder().decode(CurrentWeatherData.self, from: data) else { return }
            
            print("\(jsonData.name) \(jsonData.weather.first?.icon ?? "unknown") icon\n") // для отладки
            DispatchQueue.main.async {
                self.delegate?.updateWeatherData(currentWeather: CurrentWeather(currentWetherData: jsonData))

            }
        }
    }
}
