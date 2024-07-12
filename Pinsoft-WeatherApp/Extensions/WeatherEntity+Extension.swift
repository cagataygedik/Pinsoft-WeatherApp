//
//  WeatherEntity+Extension.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 2.07.2024.
//

import Foundation

extension WeatherEntity {
    func toWeather() -> Weather {
        var forecastList: [Forecast] = []
        if let forecastEntities = self.forecast?.allObjects as? [ForecastEntity] {
            forecastList = forecastEntities.map { $0.toForecast() }
        }
        return Weather(
            id: Int(self.id),
            city: self.city ?? "",
            country: self.country ?? "",
            latitude: self.latitude,
            longitude: self.longitude,
            temperature: self.temperature,
            weatherDescription: self.weatherDescription ?? "",
            humidity: Int(self.humidity),
            windSpeed: self.windSpeed,
            forecast: forecastList,
            isFavorite: self.isFavorite
        )
    }
}

extension ForecastEntity {
    func toForecast() -> Forecast {
        return Forecast(
            date: self.date ?? "",
            temperature: self.temperature,
            weatherDescription: self.weatherDescription ?? "",
            humidity: Int(self.humidity),
            windSpeed: self.windSpeed
        )
    }
}
