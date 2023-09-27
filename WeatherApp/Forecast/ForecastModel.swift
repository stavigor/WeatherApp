//
//  ForecastModel.swift
//  WeatherApp
//
//  Created by Игорь Растегаев on 27.09.2023.
//

import Foundation

struct ForecastrModel {
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
    
    var conditionName: (String) {
        switch id {
        case 200...232:
            return ("cloud.bolt")
        case 300...321:
            return ("cloud.drizzle")
        case 500...531:
            return ("cloud.rain")
        case 600...622:
            return ("cloud.snow")
        case 701...781:
            return ("cloud.fog")
        case 800:
            return ("sun.max")
        case 801...804:
            return ("cloud.bolt")
        default:
            return ("cloud")
        }
    }
    
}
