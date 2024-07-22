//
//  Airlibe.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 22.07.2024.
//

import Foundation

struct Airline: Codable {
    let id: Int
    let name: String
    let code: String
    let country: String
    let founded: String
    let fleetSize: String
    let headquarters: String
    let website: String
    let destinations: [Destination]
    
    enum CodingKeys: String, CodingKey {
        case id, name, code, country, founded
        case fleetSize = "fleet_size"
        case headquarters, website, destinations
    }
}

struct Destination: Codable {
    let name: String
    let code: String
}

