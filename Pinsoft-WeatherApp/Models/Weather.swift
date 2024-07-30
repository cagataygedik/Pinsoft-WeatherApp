//
//  Weather.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 2.07.2024.
//

import Foundation

struct Weather: Codable, Equatable {
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
    var isFavorite: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, city, country, latitude, longitude, temperature
        case weatherDescription = "weather_description"
        case humidity, windSpeed = "wind_speed", forecast, isFavorite
    }
    
    init(id: Int, city: String, country: String, latitude: Double, longitude: Double, temperature: Double, weatherDescription: String, humidity: Int, windSpeed: Double, forecast: [Forecast], isFavorite: Bool) {
        self.id = id
        self.city = city
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
        self.temperature = temperature
        self.weatherDescription = weatherDescription
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.forecast = forecast
        self.isFavorite = isFavorite
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        city = try container.decode(String.self, forKey: .city)
        country = try container.decode(String.self, forKey: .country)
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
        temperature = try container.decode(Double.self, forKey: .temperature)
        weatherDescription = try container.decode(String.self, forKey: .weatherDescription)
        humidity = try container.decode(Int.self, forKey: .humidity)
        windSpeed = try container.decode(Double.self, forKey: .windSpeed)
        forecast = try container.decode([Forecast].self, forKey: .forecast)
        isFavorite = false  // Initialize as false by default
    }
    
    static func == (lhs: Weather, rhs: Weather) -> Bool {
        return lhs.id == rhs.id &&
        lhs.city == rhs.city &&
        lhs.country == rhs.country &&
        lhs.latitude == rhs.latitude &&
        lhs.longitude == rhs.longitude &&
        lhs.temperature == rhs.temperature &&
        lhs.weatherDescription == rhs.weatherDescription &&
        lhs.humidity == rhs.humidity &&
        lhs.windSpeed == rhs.windSpeed &&
        lhs.forecast == rhs.forecast &&
        lhs.isFavorite == rhs.isFavorite
    }
}
