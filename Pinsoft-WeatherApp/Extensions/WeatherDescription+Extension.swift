//
//  WeatherDescription+Extension.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 4.07.2024.
//

import Foundation

extension WeatherDescription {
    var imageName: String {
        switch self {
        case .clearSky:
            return "sun.max.fill"
        case .cloudy:
            return "cloud.fill"
        case .partlyCloudy:
            return "cloud.sun.fill"
        case .rain:
            return "cloud.rain.fill"
        case .rainShowers:
            return "cloud.heavyrain.fill"
        case .rainy:
            return "cloud.drizzle.fill"
        case .scatteredClouds:
            return "cloud.bolt.fill"
        case .sunny:
            return "sun.max.fill"
        case .weatherDescriptionPartlyCloudy:
            return "cloud.sun.fill"
        }
    }
}
