//
//  WeatherServiceTests.swift
//  Pinsoft-WeatherAppTests
//
//  Created by Celil Çağatay Gedik on 8.07.2024.
//

import XCTest
@testable import Pinsoft_WeatherApp

final class WeatherServiceTests: XCTestCase {
    var weatherService: WeatherService!
    
    override func setUp() {
        super.setUp()
        weatherService = WeatherService.shared
    }
    
    override func tearDown() {
        weatherService = nil
        super.tearDown()
    }
    
    func testFetchWeatherDataSuccess() {
        let expectation = self.expectation(description: "Fetch weather data succcess")
        weatherService.fetchWeatherData { result in
            switch result {
            case .success(let weatherData):
                XCTAssertFalse(weatherData.isEmpty, "Weather data should not be empty")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success, but got error: \(error)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
