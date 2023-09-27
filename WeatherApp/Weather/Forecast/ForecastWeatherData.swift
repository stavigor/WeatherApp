//
//  ForecastWeatherData.swift
//  WeatherApp
//
//  Created by Игорь Растегаев on 26.09.2023.
//

import Foundation

struct ForecastWeatherData: Codable {
    let city: City
    let list: [List]
}

struct City: Codable {
    let name: String
}

struct List: Codable {
    var dt: Int
//    var dtTxt: String?
    var main: Main
    var weather: [Weather]

}
