//
//  ForecastWeatherVC.swift
//  WeatherApp
//
//  Created by Игорь Растегаев on 26.09.2023.
//

import UIKit
import CoreLocation

class ForecastWeatherVC: UIViewController {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var forecastAray = [ForecastrModel]()
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        tableView.delegate = self
        tableView.dataSource = self
        searchField.delegate = self
        searchField.addTarget(self, action: #selector(enterPressed), for: .editingDidEndOnExit)
        cityLabel.text = ""
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
    
//MARK: - CLLocationDelegate
extension ForecastWeatherVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchForecastWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


//MARK: - WeatherManagerDelegate
extension ForecastWeatherVC: WeatherManagerDelegate {
    func didUpdateForecast(_ weatherManager: WeatherManager, forecastArray: [ForecastrModel]) {
        print("didUpdateForecast")
        DispatchQueue.main.async {
            self.forecastAray = forecastArray
            self.tableView.reloadData()
            guard let sityName = forecastArray.first?.city else {
                self.cityLabel.text = ""
                return
            }
            self.cityLabel.text = sityName
            SwiftLoader.hide()
            DatabaseManager.shared.addForecast(forecastArray)
        }
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: TodayWeatherModel) {
        
    }
    
}

//MARK: - TableViewDelegate
extension ForecastWeatherVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastAray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell") as! ForecastCell
        
        let weather = forecastAray[indexPath.row]
        cell.buildCell(with: weather)
        
        return cell
    }
    
}

//MARK: - UITextFieldDelegate
extension ForecastWeatherVC: UITextFieldDelegate {
        
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
                        self.weatherManager.fetchForecastWeather(cityName: city)
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
