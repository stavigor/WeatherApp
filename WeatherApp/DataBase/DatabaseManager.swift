//
//  DatabaseManager.swift
//  WeatherApp
//
//  Created by Игорь Растегаев on 27.09.2023.
//

import UIKit
import CoreData

class DatabaseManager {
    static let shared = DatabaseManager()
    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func saveContext() {
        do {
            try context.save()
            print("Saving success!")
        }catch {
            print("Saving error:", error)
        }
    }
    
    func clearEntity(entityName: String){
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Clear entity error:", error)
        }
    }
    
    //MARK: - Today weather handling
    func addTodayWeather(_ todayModel: TodayWeatherModel) {
        let todayEntity = TodayEntity(context: context)
        addUpdateTodayWeather(todayEntity: todayEntity, todayModel: todayModel)
    }
    
//    func updateTodayWeather(todayModel: TodayWeatherModel, todayEntity: TodayEntity) {
//        addUpdateTodayWeather(todayEntity: todayEntity, todayModel: todayModel)
//    }
    
    private func addUpdateTodayWeather(todayEntity: TodayEntity, todayModel: TodayWeatherModel) {
        clearEntity(entityName: "TodayEntity")
        todayEntity.cityName = todayModel.city
        todayEntity.temp = todayModel.tempString
        todayEntity.weatherID = Int32(todayModel.id)
        saveContext()
    }
    
    func fetchTodayWeather() -> TodayEntity? {
        var todayEntities: [TodayEntity] = []
        do {
            todayEntities = try context.fetch(TodayEntity.fetchRequest())
        } catch {
            print("Fetch results error", error)
        }
        return todayEntities.first
    }
    
    
    //MARK: - Invoice manage
    private func addUpdateForecast(forecastEntity: ForecastEntity, forecasts: [ForecastrModel]) {
        clearEntity(entityName: "ForecastEntity")
        
        forecastEntity.cityName = forecasts[0].city
        
        for weather in forecasts {
            let list = ListEntity(context: context)
            list.temp = weather.tempString
            list.time = weather.tempString
            list.weatherID = Int32(weather.id)
            
            list.forecast = forecastEntity
            forecastEntity.addToList(list)
        }
        
        saveContext()
    }
    
    func addForecast(_ forecasts: [ForecastrModel]) {
        let forecastEntity = ForecastEntity(context: context)
        addUpdateForecast(forecastEntity: forecastEntity, forecasts: forecasts)
    }
    
    func fetchRForecast() -> ForecastEntity? {
        var forecastEntities: [ForecastEntity] = []
        do {
            forecastEntities = try context.fetch(ForecastEntity.fetchRequest())
        }catch {
            print("Fetch results error", error)
        }
        return forecastEntities.last
    }

}
