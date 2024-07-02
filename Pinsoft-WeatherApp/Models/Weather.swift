//
//  Weather.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 2.07.2024.
//

import Foundation

struct Weather: Codable {
    let id: Int
    let city: String
    let country: String
    let latitude: Double
    let longitude: Double
    let temperature: Double
    let weatherDescription: String
    let humidity: Int
    let windSpeed: Double
    let forecast: [Forecast]
    
    enum CodingKeys: String, CodingKey {
        case id, city, country, latitude, longitude, temperature
        case weatherDescription = "weather_description"
        case humidity, windSpeed = "wind_speed", forecast
    }
}
