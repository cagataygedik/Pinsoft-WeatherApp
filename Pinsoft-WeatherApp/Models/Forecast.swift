//
//  Forecast.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 2.07.2024.
//

import Foundation

struct Forecast: Codable, Equatable {
    let date: String
    let temperature: Double
    let weatherDescription: String
    let humidity: Int
    let windSpeed: Double
    
    enum CodingKeys: String, CodingKey {
        case date, temperature
        case weatherDescription = "weather_description"
        case humidity, windSpeed = "wind_speed"
    }
    
    var dateAsDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: date)
    }
    
    static func == (lhs: Forecast, rhs: Forecast) -> Bool {
        return lhs.date == rhs.date &&
        lhs.temperature == rhs.temperature &&
        lhs.weatherDescription == rhs.weatherDescription &&
        lhs.humidity == rhs.humidity &&
        lhs.windSpeed == rhs.windSpeed
    }
}
