//
//  ViewController.swift
//  WeatherApp
//
//  Created by Игорь Растегаев on 26.09.2023.
//

import UIKit
import CoreLocation

class TodayWeatherVC: UIViewController {
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var tipsView: UIView!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        tipsView.addBlueRoundBorder(16)
        
        searchField.delegate = self
        searchField.addTarget(self, action: #selector(enterPressed), for: .editingDidEndOnExit)
        weatherManager.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
                
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.requestLocation()
    }

    
    @IBAction func getCurrentLocation(_ sender: Any) {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                switch self.locationManager.authorizationStatus {
                case .notDetermined, .restricted, .denied:
                    print("No access")
                    DispatchQueue.main.async {
                        self.showAlert()
                    }
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                    SwiftLoader.show(title: "Fetching...", animated: true)
                    self.locationManager.requestLocation()
                @unknown default:
                    break
                }
            } else {
                print("Location services are not enabled")
            }
        }
        
    }
    
    func showAlert() {
        let message = "Go to app settings to allow locations access"
        let alertController = UIAlertController(title: "Location service not permitted", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .default, handler: { _ in}))
        present(alertController, animated: true, completion: nil)
    }

    @objc func enterPressed(){
        //do something with typed text if needed
        searchField.resignFirstResponder()
    }
}

//MARK: - UITextFieldDelegate
extension TodayWeatherVC: UITextFieldDelegate {
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "City name"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchField.text {
            DispatchQueue.global().async {
                if CLLocationManager.locationServicesEnabled() {
                    switch self.locationManager.authorizationStatus {
                    case .notDetermined, .restricted, .denied:
                        print("No access")
                        DispatchQueue.main.async {
                            self.showAlert()
                        }
                    case .authorizedAlways, .authorizedWhenInUse:
                        print("Access")
                        self.weatherManager.fetchCurrentWeather(cityName: city)
                    @unknown default:
                        break
                    }
                } else {
                    print("Location services are not enabled")
                }
            }
            
        }
        
        searchField.text = ""
        
    }
}

//MARK: - CLLocationDelegate
extension TodayWeatherVC: CLLocationManagerDelegate {
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchCurrentWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


//MARK: - WeatherManagerDelegate
extension TodayWeatherVC: WeatherManagerDelegate {
    func didUpdateForecast(_ weatherManager: WeatherManager, forecastArray: [ForecastrModel]) {
    }
    
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: TodayWeatherModel) {
        DispatchQueue.main.async {
            self.weatherLabel.text = weather.tempString
            self.weatherIcon.image = UIImage(systemName: weather.conditionName.0)
            self.cityLabel.text = weather.city
            self.tipsLabel.text = weather.conditionName.1
            SwiftLoader.hide()
            DatabaseManager.shared.addTodayWeather(weather)
        }
        
       
    }
    
}
