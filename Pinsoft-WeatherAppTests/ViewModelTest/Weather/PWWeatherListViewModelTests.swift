//
//  WeatherViewModelTests.swift
//  Pinsoft-WeatherAppTests
//
//  Created by Celil Çağatay Gedik on 8.07.2024.
//

import XCTest
@testable import Pinsoft_WeatherApp

final class MockWeatherService: WeatherServiceConformable {
    var fetchWeatherDataResult: Result<[Weather], PWError>?
    
    func fetchWeatherData(page: Int, completion: @escaping (Result<[Pinsoft_WeatherApp.Weather], PWError>) -> Void) {
        if let result = fetchWeatherDataResult { completion(result) }
    }
}

final class PWWeatherListViewModelTests: XCTestCase {
    var sut: PWWeatherListViewModel!
    var service: MockWeatherService!
    
    override func setUp() {
        super.setUp()
        service = MockWeatherService()
        sut = PWWeatherListViewModel(weatherService: service)
    }
    
    override func tearDown() {
        service = nil
        sut = nil
        super.tearDown()
    }
    
    func testViewModelInit() {
        XCTAssertEqual(sut.weatherData.count, 0)
        XCTAssertEqual(sut.filteredWeatherData.count, 0)
        XCTAssertEqual(sut.paginatedWeatherData.count, 0)
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.currentPage, 1)
    }
    
    func testFetchWeatherSuccess() {
        let weatherData = [Weather(id: 1, city: "TestCity", country: "TestCountry", latitude: 40.7128, longitude: -74.0060, temperature: 25.0, weatherDescription: "Sunny", humidity: 60, windSpeed: 10.0, forecast: [], isFavorite: false)]
        service.fetchWeatherDataResult = .success(weatherData)
        
        let expectation = XCTestExpectation(description: "Weather data fetched")
        sut.updateUI = {
            XCTAssertEqual(self.sut.weatherData.count, 1)
            XCTAssertEqual(self.sut.filteredWeatherData.count ,1)
            XCTAssertEqual(self.sut.paginatedWeatherData.count, 1)
            expectation.fulfill()
        }
        sut.fetchWeather()
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchWeatherFailure() {
        let error = PWError.networkError(NSError(domain: "", code: 0, userInfo: nil))
        service.fetchWeatherDataResult = .failure(error)
        
        let expectation = XCTestExpectation(description: "Weather data fetch failed")
        sut.showError = { err in
            if case .networkError = err {
                expectation.fulfill()
            } else {
                XCTFail("Expected networkError, but got \(err)")
            }
        }
        
        sut.fetchWeather()
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(sut.weatherData.count, 0)
        XCTAssertEqual(sut.filteredWeatherData.count, 0)
        XCTAssertEqual(sut.paginatedWeatherData.count, 0)
    }
    
    func testLoadNextPage() {
        let weatherData = (1...15).map {
            Weather(id: $0, city: "TestCity\($0)", country: "TestCountry", latitude: 40.7128, longitude: 40.7128, temperature: 25.0, weatherDescription: "Sunny", humidity: 60, windSpeed: 10.0, forecast: [], isFavorite: false)
        }
        service.fetchWeatherDataResult = .success(weatherData)
        
        let expectation = XCTestExpectation(description: "Next page data loaded")
        sut.updateUI = {
            if self.sut.currentPage == 2 {
                XCTAssertEqual(self.sut.paginatedWeatherData.count, 10)
            } else if self.sut.currentPage == 3 {
                XCTAssertEqual(self.sut.paginatedWeatherData.count, 15)
                expectation.fulfill()
            }
        }
        sut.fetchWeather()
        sut.loadNextPage()
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFilterWeather() {
        let weatherData = [Weather(id: 1, city: "New York", country: "USA", latitude: 40.7128, longitude: -74.0060, temperature: 25.0, weatherDescription: "Sunny", humidity: 60, windSpeed: 10.0, forecast: [], isFavorite: false),
                           Weather(id: 2, city: "Los Angeles", country: "USA", latitude: 34.0522, longitude: -118.2437, temperature: 20.0, weatherDescription: "Cloudy", humidity: 70, windSpeed: 5.0, forecast: [], isFavorite: false)]
        service.fetchWeatherDataResult = .success(weatherData)
        sut.fetchWeather()
        
        sut.filterWeather(by: "New")
        XCTAssertEqual(sut.filteredWeatherData.count, 1)
        XCTAssertEqual(sut.filteredWeatherData.first?.city, "New York")
        
        sut.filterWeather(by: "Los")
        XCTAssertEqual(sut.filteredWeatherData.count, 1)
        XCTAssertEqual(sut.filteredWeatherData.first?.city, "Los Angeles")
        
        sut.filterWeather(by: "")
        XCTAssertEqual(sut.filteredWeatherData.count, 2)
    }
}
