//
//  TodayWeatherModel.swift
//  WeatherApp
//
//  Created by Игорь Растегаев on 26.09.2023.
//

import Foundation

struct TodayWeatherModel {
    let id: Int
    let city: String
    let temp: Double
    let time: Int
    
    var tempString: String {
        return String(format: "%.0f", temp)
    }
    
    var timeString: String{
        let date = Date(timeIntervalSince1970: TimeInterval(time))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd \n HH:mm"
        return dateFormatter.string(from: date)
    }
    
    var conditionName: (String, String) {
        switch id {
        case 200...232:
            return ("cloud.bolt", "Possible lightning. Be careful!")
        case 300...321:
            return ("cloud.drizzle", "Drizzle.\nPut on your mackintosh")
        case 500...531:
            return ("cloud.rain", "It's raining. Take an umbrella!")
        case 600...622:
            return ("cloud.snow", "Snow. Put on your mittens.")
        case 701...781:
            return ("cloud.fog", "Fog. Visibility is limited!")
        case 800:
            return ("sun.max", "It's sunny. Wear a hat")
        case 801...804:
            return ("cloud.bolt", "Possible lightning. Be careful!")
        default:
            return ("cloud", "Cloudy. Time for a walk")
        }
    }
    
}
