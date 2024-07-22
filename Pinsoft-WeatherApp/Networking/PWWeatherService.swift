//
//  WeatherService.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 2.07.2024.
//

import Alamofire

protocol WeatherServiceConformable {
    func fetchWeatherData(page: Int, completion: @escaping (Result<[Weather], Error>) -> Void)
}

final class PWWeatherService: WeatherServiceConformable {
    static let shared = PWWeatherService()
    private let APIManager: PWAPIManager
//    private var currentPage = 1
    
    init(apiManager: PWAPIManager = PWAPIManager(networkService: PWNetworkService())) {
        self.APIManager = apiManager
    }
    
    func fetchWeatherData(page: Int, completion: @escaping (Result<[Weather], Error>) -> Void) {
        APIManager.requestWeatherData(page: page) { result in
            switch result {
            case .success(let weatherData):
                let updatedWeatherData = CoreDataStack.shared.updateWeatherWithFavorites(weatherData)
                CoreDataStack.shared.deleteAllWeatherData()
                CoreDataStack.shared.saveWeatherData(updatedWeatherData)
                completion(.success(updatedWeatherData))
            case .failure(let error):
                let offlineData = CoreDataStack.shared.fetchWeatherData().map { $0.toWeather() }
                if !offlineData.isEmpty {
                    completion(.success(offlineData))
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
}

