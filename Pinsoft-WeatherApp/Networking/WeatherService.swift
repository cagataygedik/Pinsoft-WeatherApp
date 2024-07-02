//
//  WeatherService.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 2.07.2024.
//

import Alamofire

class WeatherService {
    static let shared = WeatherService()
    private let baseURL = "https://freetestapi.com/api/v1/weathers"
    private var currentPage = 1
    
    func fetchWeatherData(completion: @escaping (Result<[Weather], Error>) -> Void) {
        let url = "\(baseURL)?page=\(currentPage)"
        AF.request(url).responseDecodable(of: [Weather].self) { response in
            switch response.result {
            case .success(let weatherData):
                CoreDataStack.shared.deleteAllWeatherData()
                CoreDataStack.shared.saveWeatherData(weatherData)
                completion(.success(weatherData))
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
    
    func fetchNextPage(completion: @escaping (Result<[Weather], Error>) -> Void) {
        currentPage += 1
        fetchWeatherData(completion: completion)
    }
}
