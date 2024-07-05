//
//  PWWeatherDetailViewModel.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 5.07.2024.
//

import Foundation

final class PWWeatherDetailViewModel {
    var weather: Weather
    
    init(weather: Weather) {
        self.weather = weather
    }
    
    var city: String {
        return weather.city
    }
    
    var country: String {
        return weather.country
    }
    
    var temperature: String {
        return "\(weather.temperature)°C"
    }
    
    var weatherDescription: String {
        return weather.weatherDescription
    }
    
    var humidity: String {
        return "\(weather.humidity)%"
    }
    
    var windSpeed: String {
        return "\(weather.windSpeed)KM/H"
    }
    
    var forecast: [Forecast] {
        let sortedForecast = weather.forecast.sorted { ($0.dateAsDate ?? Date()) < ($1.dateAsDate ?? Date()) }
        var uniqueForecast = [Forecast]()
        
        for forecast in sortedForecast {
            if uniqueForecast.isEmpty || uniqueForecast.last?.date != forecast.date {
                uniqueForecast.append(forecast)
            }
        }
        
        return Array(uniqueForecast.prefix(2))
    }
    
    var isFavorite: Bool {
        return weather.isFavorite
    }
    
    func toggleFavorite() {
        weather.isFavorite.toggle()
        if weather.isFavorite {
            PWFavoritesViewModel.shared.addFavorite(weather)
        } else {
            PWFavoritesViewModel.shared.removeFavorite(weather)
        }
    }
}
