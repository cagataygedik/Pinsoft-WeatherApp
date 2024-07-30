//
//  PWWeatherServiceTests.swift
//  Pinsoft-WeatherAppTests
//
//  Created by Celil Çağatay Gedik on 26.07.2024.
//

import XCTest
import Alamofire
@testable import Pinsoft_WeatherApp

final class MockNetworkService: NetworkServiceConformable {
    var result: Result<Data, PWError>?
    
    func request<T: Decodable>(endpoint: PWEndpoint, completion: @escaping (Result<T, PWError>) -> Void) {
        guard let result = result else {
            completion(.failure(.customError("No result set in mock")))
            return
        }
        switch result {
        case .success(let data):
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}

final class PWWeatherServiceTests: XCTestCase {
    var sut: PWWeatherService!
    var mockNetworkService: MockNetworkService!
    var coreDataStack: CoreDataStack!
    
    override  func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        let apiManager = PWAPIManager(networkService: mockNetworkService)
        sut = PWWeatherService(apiManager: apiManager)
        coreDataStack = CoreDataStack.shared
        clearCoreData()
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        clearCoreData()
        super.tearDown()
    }
    
    func clearCoreData() {
        coreDataStack.deleteAllWeatherData()
    }
    
    func testFetchWeatherDataSuccess() {
        let mockWeatherData = [Weather(id: 1, city: "Burdur", country: "Turkiye", latitude: 15.000, longitude: 15.000, temperature: 25.0, weatherDescription: "Sunny", humidity: 10, windSpeed: 10, forecast: [], isFavorite: false)]
        let mockData = try! JSONEncoder().encode(mockWeatherData)
        mockNetworkService.result = .success(mockData)
        
        let expectation = self.expectation(description: "Fetch weather data success")
        
        sut.fetchWeatherData(page: 1) { result in
            switch result {
            case .success(let weatherData):
                XCTAssertEqual(weatherData.count, 1)
                XCTAssertEqual(weatherData.first?.city, "Burdur")
                expectation.fulfill()
            case .failure(let failure):
                XCTFail("Expected success but got \(failure)")
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchWeatherDataFailure() {
        let mockError = PWError.networkError(AFError.explicitlyCancelled)
        mockNetworkService.result = .failure(mockError)
        
        let expectation = self.expectation(description: "Fetch weather data failure")
        
        sut.fetchWeatherData(page: 1) { result in
            switch result {
            case .success:
                XCTFail("expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, mockError.localizedDescription)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
}
