//
//  NetworkService.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 22.07.2024.
//

import Alamofire

protocol NetworkServiceConformable {
    func request<T: Decodable>(endpoint: PWEndpoint, completion: @escaping (Result<T, PWError>) -> Void)
}

final class PWNetworkService: NetworkServiceConformable {
    private let baseURL: String
    
    init(baseUrl: String = APIConstants.baseURL) {
        self.baseURL = baseUrl
    }
    
    func request<T: Decodable>(endpoint: PWEndpoint, completion: @escaping (Result<T, PWError>) -> Void) {
        let url = baseURL + endpoint.path
        
        AF.request(url, method: endpoint.method, parameters: endpoint.parameters, encoding: URLEncoding.default, headers: endpoint.headers).validate().responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(.networkError(error)))
            }
        }
    }
}
