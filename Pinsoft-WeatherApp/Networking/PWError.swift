//
//  PWError.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 24.07.2024.
//

import Foundation

enum PWError: Error {
    case networkError(Error)
    case decodingError(Error)
    case coreDataError(Error)
    case customError(String)
    
    var localizedDescription: String {
        switch self {
        case .networkError:
            return "There was a problem with the network. Please try again later."
        case .decodingError:
            return "There was a problem processing the data. Please try again later."
        case .coreDataError:
            return "There was a problem saving or retrieving data. Please try again later."
        case .customError(let message):
            return message
        }
    }
}
