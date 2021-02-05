//
//  ViewController.swift
//  Weather
//
//  Created by Bobrovko Ilya on 19.01.2021.
//

import UIKit
import CoreLocation

protocol NetworkWeatherManagerDelegate {
    func updateWeatherData(currentWeather: CurrentWeather)
    func activateLoadingIndicator()
    func deactivateLoadingIndicator()
    func presentErrorAlert(errorType: ErrorType)
}

class MainViewController: UIViewController {

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var additionalInfoLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let networkWeatherManager = NetworkWeatherManager()
    private let locationManager = CLLocationManager()
        
    @IBAction func searchCity(_ sender: Any) {
        presentAlertController()
    }
    
    @IBAction func fetchWeatherForCurrentLocation(_ sender: Any) {
        activateLoadingIndicator()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        } else {
            presentErrorAlert(errorType: .unavailableLocationServices)
            deactivateLoadingIndicator()
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkWeatherManager.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        
                activateLoadingIndicator()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        } else {
            networkWeatherManager.fetchCurrentWeather(requestType: .city(name: "Siattle"))
        }
    }

}

//MARK: - AlertControllers

extension MainViewController {
    func presentAlertController() {
        let alert = UIAlertController(title: "Enter location name", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            let sities = ["Tokyo", "Moscow", "Barcelona", "New York", "Paris", "Los Angeles", "London"]
            textField.placeholder = sities.randomElement()
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Search", style: .default, handler: { _ in
            guard var locationName = alert.textFields?.first?.text else { return }
            locationName = locationName.split(separator: " ").joined(separator: "%20")
            print("searth weather for \(locationName)") //delete this
            self.networkWeatherManager.fetchCurrentWeather(requestType: .city(name: locationName))
        }))
        
        present(alert, animated: true)
    }
    
}

//MARK: - NetworkWeatherManagerDelegare

extension MainViewController: NetworkWeatherManagerDelegate {
    
    func updateWeatherData(currentWeather: CurrentWeather) {
        cityNameLabel.text = currentWeather.cityName
        temperatureLabel.text = currentWeather.currentTempetatureString + "°"
        additionalInfoLabel.text = "Min \(currentWeather.minTemperatureString)°, max \(currentWeather.maxTemperatureString)°"
        currentWeatherImage.image = UIImage(systemName: currentWeather.weatherImageName)
        
        deactivateLoadingIndicator()
    }
    
    func activateLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    func deactivateLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }

    func presentErrorAlert(errorType: ErrorType) {
        var alert = UIAlertController()
        switch errorType {
        case .ivalidLocationError:
            alert = UIAlertController(title: "Location error", message: "Invalid location name. Please try again.", preferredStyle: .alert)
        case .networkError:
            alert = UIAlertController(title: "Network error", message: "No internet connection. Please try again.", preferredStyle: .alert)
        case .unavailableLocationServices:
            alert = UIAlertController(title: "Unavailable Location Services", message: "REMAKE THIS STRING.", preferredStyle: .alert)
        }
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}



//MARK: - LocationManagerDelegate

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        networkWeatherManager.fetchCurrentWeather(requestType: .coordinate(latitude: latitude, longitude: longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        presentErrorAlert(errorType: .unavailableLocationServices)
        deactivateLoadingIndicator()
    }
}
