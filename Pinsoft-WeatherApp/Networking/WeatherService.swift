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
    
    func fetchWeatherData(completion: @escaping (Result<[Weather], Error>) -> Void) {
        AF.request(baseURL).responseDecodable(of: [Weather].self) { response in
            switch response.result {
            case .success(let weatherData):
                completion(.success(weatherData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
