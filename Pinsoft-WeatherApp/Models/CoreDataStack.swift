//
//  CoreDataStack.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 2.07.2024.
//

import CoreData

protocol CoreDataStackConformable {
    func saveFavoriteWeatherData(_ weather: Weather)
    func removeFavoriteWeatherData(_ weather: Weather)
    func fetchFavoriteWeatherData() -> [WeatherEntity]
    func deleteAllWeatherData()
}

final class CoreDataStack: CoreDataStackConformable {
    static let shared = CoreDataStack()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Pinsoft_WeatherApp")
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
            let fetchRequest: NSFetchRequest<WeatherEntity> = WeatherEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", weather.id)
            
            do {
                let results = try context.fetch(fetchRequest)
                let entity: WeatherEntity
                
                if let existingEntity = results.first {
                    entity = existingEntity
                } else {
                    entity = WeatherEntity(context: context)
                }
                entity.id = Int64(weather.id)
                entity.city = weather.city
                entity.country = weather.country
                entity.latitude = weather.latitude
                entity.longitude = weather.longitude
                entity.temperature = weather.temperature
                entity.weatherDescription = weather.weatherDescription
                entity.humidity = Int64(weather.humidity)
                entity.windSpeed = weather.windSpeed
                entity.isFavorite = weather.isFavorite
                
                if let forecasts = entity.forecast as? Set<ForecastEntity> {
                    for forecast in forecasts {
                        context.delete(forecast)
                    }
                }
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
            } catch {
                print("error saving data: \(error)")
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
    
    func fetchFavoriteWeatherData() -> [WeatherEntity] {
        let request: NSFetchRequest<WeatherEntity> = WeatherEntity.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite == true")
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching favorite data: \(error)")
            return []
        }
    }
    
    func saveFavoriteWeatherData(_ weather: Weather) {
        let request: NSFetchRequest<WeatherEntity> = WeatherEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", weather.id)
        
        do {
            let results = try context.fetch(request)
            let entity: WeatherEntity
            
            if let existingEntity = results.first {
                entity = existingEntity
            } else {
                entity = WeatherEntity(context: context)
            }
            
            entity.id = Int64(weather.id)
            entity.city = weather.city
            entity.country = weather.country
            entity.latitude = weather.latitude
            entity.longitude = weather.longitude
            entity.temperature = weather.temperature
            entity.weatherDescription = weather.weatherDescription
            entity.humidity = Int64(weather.humidity)
            entity.windSpeed = weather.windSpeed
            entity.isFavorite = true
            
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
            
            saveContext()
        } catch {
            print("Error saving favorite data: \(error)")
        }
    }
    
    func removeFavoriteWeatherData(_ weather: Weather) {
        let request: NSFetchRequest<WeatherEntity> = WeatherEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", weather.id)
        do {
            let results = try context.fetch(request)
            if let entity = results.first {
                entity.isFavorite = false
                saveContext()
            }
        } catch {
            print("Error removing favorite data: \(error)")
        }
    }
    
    func updateWeatherWithFavorites(_ weatherData: [Weather]) -> [Weather] {
        let favoriteEntities = CoreDataStack.shared.fetchFavoriteWeatherData()
        let favoriteIDs = Set(favoriteEntities.map { Int($0.id) })
        
        return weatherData.map { weather in
            var updatedWeather = weather
            if favoriteIDs.contains(weather.id) {
                updatedWeather.isFavorite = true
            }
            return updatedWeather
        }
    }
}


