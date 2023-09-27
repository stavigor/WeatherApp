//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Игорь Растегаев on 26.09.2023.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: TodayWeatherModel)
    func didUpdateForecast(_ weatherManager: WeatherManager, forecastArray: [ForecastrModel])
}



struct WeatherManager {
    private let currentWeatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=13efb6f71400508a0c4ecc39be12a187"
    private let forecastWeatherURL = "https://api.openweathermap.org/data/2.5/forecast?units=metric&appid=13efb6f71400508a0c4ecc39be12a187"

    
    var delegate: WeatherManagerDelegate?
    
    //MARK: - Fetch today weather
    func fetchCurrentWeather(cityName: String) {
        let urlString = "\(currentWeatherURL)&q=\(cityName)"
        performCurrentRequest(with: urlString)
    }
    
    func fetchCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(currentWeatherURL)&lat=\(latitude)&lon=\(longitude)"
        performCurrentRequest(with: urlString)
    }
    
    func performCurrentRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    if let weatherEntity = DatabaseManager.shared.fetchTodayWeather(){
                        let weather = TodayWeatherModel(id: Int(weatherEntity.weatherID),
                                                        city: weatherEntity.cityName ?? "No data",
                                                        temp: Double(weatherEntity.temp ?? "0.0") ?? 0.0,
                                                        time: Int(Date().timeIntervalSince1970))
                        print("\nToday offline:")
                        dump(weather)
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                    return
                }
                if let safeData = data {
                    if let weather = self.parseTodayJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseTodayJSON(_ weatherData: Data) -> TodayWeatherModel? {
        do {
            let decodedData = try JSONDecoder().decode(TodayWeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let time = decodedData.dt
            let weather = TodayWeatherModel(id: id, city: name, temp: temp, time: time)
            print("\nToday online:")
            dump(weather)
            return weather
            
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    
    //MARK: - Fetch forecast weather
    func fetchForecastWeather(cityName: String) {
        let urlString = "\(forecastWeatherURL)&q=\(cityName)"
        performForecastRequest(with: urlString)
    }
    
    func fetchForecastWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(forecastWeatherURL)&lat=\(latitude)&lon=\(longitude)"
        performForecastRequest(with: urlString)
    }

    func performForecastRequest(with urlString: String) {
        SwiftLoader.show(title: "Fetching...", animated: true)
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("TASK ERROR")
                    
                    print(error!.localizedDescription)
                    print("\nForecat offline:")
                    if let forecastEntity = DatabaseManager.shared.fetchRForecast(){
                        
                        var forecastArray: [ForecastrModel] = []
                        let listArray = forecastEntity.list?.allObjects as! [ListEntity]
                        for list in listArray {
                            let forecast = ForecastrModel(id: Int(list.weatherID),
                                                          city: forecastEntity.cityName ?? "No data",
                                                          temp: Double(list.temp ?? "0.0") ?? 0.0,
                                                          time: Int(list.time ?? "0.0") ?? Int((Date().timeIntervalSince1970)))
                            forecastArray.append(forecast)
                        }
                        print("forecastArray", forecastArray.count)
                        self.delegate?.didUpdateForecast(self, forecastArray: forecastArray)
                    }
                    SwiftLoader.hide()
                    return
                }
                if let safeData = data {
                    if let forecastArray = self.parseForecastJSON(safeData) {
                        self.delegate?.didUpdateForecast(self, forecastArray: forecastArray)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseForecastJSON(_ weatherData: Data) -> [ForecastrModel]? {
        var forecastArray: [ForecastrModel] = []
        do {
            let decodedData = try JSONDecoder().decode(ForecastWeatherData.self, from: weatherData)
            let name = decodedData.city.name
            let list = decodedData.list
            
            for weather in list{
                let id = weather.weather[0].id
                let time = weather.dt
                let temp = weather.main.temp
                let forecast = ForecastrModel(id: id, city: name, temp: temp, time: time)
                forecastArray.append(forecast)
            }
            print("\nForecat online:")
            print("forecastArray", forecastArray.count)
//            dump(forecastArray[0])
            return forecastArray
        } catch {
            SwiftLoader.hide()
            print("PARSE ERROR")
            print(error.localizedDescription)
            return nil
        }
    }

}

