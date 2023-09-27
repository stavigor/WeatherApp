//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Игорь Растегаев on 26.09.2023.
//

import Foundation

struct TodayWeatherData: Codable {
    let name: String
    let dt: Int
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
}
