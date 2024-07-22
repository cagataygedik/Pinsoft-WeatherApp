//
//  Endpoint.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 22.07.2024.
//

import Foundation
import Alamofire

enum PWEndpoint {
    case weather(page: Int)
    
    var path: String {
        switch self {
        case .weather(let page):
            return "/api/v1/weathers?page=\(page)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .weather:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .weather:
            return nil
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
