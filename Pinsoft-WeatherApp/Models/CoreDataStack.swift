//
//  CoreDataStack.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 2.07.2024.
//

import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WeatherApp")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func fetchWeatherData() -> [WeatherEntity] {
        let request: NSFetchRequest<WeatherEntity> = WeatherEntity.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching data: \(error)")
            return []
        }
    }

    func saveWeatherData(_ weatherData: [Weather]) {
        for weather in weatherData {
            let entity = WeatherEntity(context: context)
            entity.id = Int64(weather.id)
            entity.city = weather.city
            entity.country = weather.country
            entity.latitude = weather.latitude
            entity.longitude = weather.longitude
            entity.temperature = weather.temperature
            entity.weatherDescription = weather.weatherDescription
            entity.humidity = Int64(weather.humidity)
            entity.windSpeed = weather.windSpeed

            for forecast in weather.forecast {
                let forecastEntity = ForecastEntity(context: context)
                forecastEntity.date = forecast.date
                forecastEntity.temperature = forecast.temperature
                forecastEntity.weatherDescription = forecast.weatherDescription
                forecastEntity.humidity = Int64(forecast.humidity)
                forecastEntity.windSpeed = forecast.windSpeed
                forecastEntity.weather = entity
                entity.addToForecast(forecastEntity)
            }
        }
        saveContext()
    }

    func deleteAllWeatherData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = WeatherEntity.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDeleteRequest)
        } catch {
            print("Error deleting data: \(error)")
        }
    }
}

