//
//  WeatherViewModelTests.swift
//  Pinsoft-WeatherAppTests
//
//  Created by Celil Çağatay Gedik on 8.07.2024.
//

import XCTest
@testable import Pinsoft_WeatherApp

final class MockWeatherService: WeatherServiceConformable {
    var fetchWeatherDataResult: Result<[Weather], Error>?
    var fetchNextPageResult: Result<[Weather], Error>?
    
    func fetchWeatherData(completion: @escaping (Result<[Pinsoft_WeatherApp.Weather], any Error>) -> Void) {
        if let result = fetchWeatherDataResult { completion(result) }
    }
    
    func fetchNextPage(completion: @escaping (Result<[Pinsoft_WeatherApp.Weather], any Error>) -> Void) {
        if let result = fetchNextPageResult { completion(result) }
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
        XCTAssertFalse(sut.isLoading)
    }
    
    func testFetchWeatherSuccess() {
        let weatherData = [Weather(id: 1, city: "TestCity", country: "TestCountry", latitude: 40.7128, longitude: -74.0060, temperature: 25.0, weatherDescription: "Sunny", humidity: 60, windSpeed: 10.0, forecast: [], isFavorite: false)]
        service.fetchWeatherDataResult = .success(weatherData)
        
        let expectation = XCTestExpectation(description: "Weather data fetched")
        sut.updateUI = {
            XCTAssertEqual(self.sut.weatherData.count, 1)
            XCTAssertEqual(self.sut.filteredWeatherData.count ,1)
 //           XCTAssertFalse(sut.isLoading)
            expectation.fulfill()
        }
        sut.fetchWeather()
//        XCTAssertTrue(sut.isLoading)
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchWeatherFailure() {
        let error = NSError(domain: "", code: 0, userInfo: nil)
        service.fetchWeatherDataResult = .failure(error)
        
        sut.fetchWeather()
        
//        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.weatherData.count, 0)
        XCTAssertEqual(sut.filteredWeatherData.count, 0)
    }
    
    func testFetchNextPageSuccess() {
        let initialWeatherData = [Weather(id: 1, city: "TestCity1", country: "TestCountry", latitude: 40.7128, longitude: -74.0060, temperature: 25.0, weatherDescription: "Sunny", humidity: 60, windSpeed: 10.0, forecast: [], isFavorite: false
                                         )]
        let nextPageWeatherData = [Weather(id: 2, city: "TestCity2", country: "TestCountry", latitude: 34.0522, longitude: -118.2437, temperature: 20.0, weatherDescription: "Cloudy", humidity: 70, windSpeed: 5.0, forecast: [], isFavorite: false
                                          )]
        service.fetchWeatherDataResult = .success(initialWeatherData)
        sut.fetchWeather()
        service.fetchNextPageResult = .success(nextPageWeatherData)
        
        let expectation = XCTestExpectation(description: "Next page data fetched")
        sut.updateUI = {
            XCTAssertEqual(self.sut.weatherData.count, 2)
            XCTAssertEqual(self.sut.filteredWeatherData.count, 2)
//            XCTAssertFalse(sut.isLoading)
            expectation.fulfill()
        }
        sut.fetchNextPage()
//        XCTAssertTrue(sut.isLoading)
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
