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
    
    func requestWeatherData(page: Int, completion: @escaping (Result<[Weather], Error>) -> Void) {
        let endpoint = PWEndpoint.weather(page: page)
        networkService.request(endpoint: endpoint, completion: completion)
    }
    
    func requestAirlineData(completion: @escaping (Result<[Airline], Error>) -> Void) {
        let endpoint = PWEndpoint.airlines
        networkService.request(endpoint: endpoint, completion: completion)
    }
}
