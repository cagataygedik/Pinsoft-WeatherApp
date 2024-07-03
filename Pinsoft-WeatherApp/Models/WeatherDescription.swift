//
//  WeatherDescription.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 3.07.2024.
//

import Foundation

public enum WeatherDescription: String, Equatable, Codable {
    case clearSky = "Clear sky"
    case cloudy = "Cloudy"
    case partlyCloudy = "Partly cloudy"
    case rain = "Rain"
    case rainShowers = "Rain showers"
    case rainy = "Rainy"
    case scatteredClouds = "Scattered clouds"
    case sunny = "Sunny"
    case weatherDescriptionPartlyCloudy = "Partly Cloudy"
}
