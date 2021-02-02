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
    func activateIndicator()
    func deactivateIndicator()
    func presentErrorAlert(errorType: ErrorType)
}

class MainViewController: UIViewController {

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var additionalInfoLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let networkWeatherManager = NetworkWeatherManager()
    let locationManager = CLLocationManager()
        
    @IBAction func searchCity(_ sender: Any) {
        presentAlertController()
    }
    
    @IBAction func fetchWeatherForCurrentLocation(_ sender: Any) {
        activateIndicator()
        if CLLocationManager.locationServicesEnabled() {
            print("location services enable")
            locationManager.requestLocation()
        } else {
            print("location services unenable\n")
            presentErrorAlert(errorType: .unavailableLocationServices)
            deactivateIndicator()
        }
        //locationManager.requestLocation()
        print("current location button")

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkWeatherManager.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        
        activateIndicator()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        } else {
            print("location services unenable")
            networkWeatherManager.fetchCurrentWeather(requestType: .city(name: "Siattle"))
        }
    }

}

//MARK: - AlertControllers

extension MainViewController {
    func presentAlertController() {
        let alert = UIAlertController(title: "Enter city name", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Tokyo"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Search", style: .default, handler: { _ in
            guard var cityName = alert.textFields?.first?.text else { return }
            cityName = cityName.split(separator: " ").joined(separator: "%20")
            print("searth for \(cityName)")
            self.networkWeatherManager.fetchCurrentWeather(requestType: .city(name: cityName))
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
        
        deactivateIndicator()
    }
    
    func activateIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    func deactivateIndicator() {
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
            alert = UIAlertController(title: "UnavailableLocationServices", message: "REMAKE THIS STRING.", preferredStyle: .alert)
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
        deactivateIndicator()
    }
}
