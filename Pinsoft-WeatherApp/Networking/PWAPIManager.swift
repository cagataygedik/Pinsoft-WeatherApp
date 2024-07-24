//
//  APIManager.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 22.07.2024.
//

import Foundation

final class PWAPIManager {
    private let networkService: NetworkServiceConformable
    
    init(networkService: NetworkServiceConformable) {
        self.networkService = networkService
    }
    
    func requestWeatherData(page: Int, completion: @escaping (Result<[Weather], PWError>) -> Void) {
        let endpoint = PWEndpoint.weather(page: page)
        networkService.request(endpoint: endpoint, completion: completion)
    }
}
