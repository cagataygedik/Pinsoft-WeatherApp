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
            return "sun.min"
        case .cloudy:
            return "cloud"
        case .partlyCloudy:
            return "cloud.sun"
        case .rain:
            return "cloud.rain"
        case .rainShowers:
            return "cloud.heavyrain"
        case .rainy:
            return "cloud.drizzle"
        case .scatteredClouds:
            return "cloud.bolt"
        case .sunny:
            return "sun.max"
        case .weatherDescriptionPartlyCloudy:
            return "cloud.sun"
        }
    }
}
