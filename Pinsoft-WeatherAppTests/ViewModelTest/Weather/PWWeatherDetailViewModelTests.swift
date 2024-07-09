//
//  PWWeatherDetailViewModelTests.swift
//  Pinsoft-WeatherAppTests
//
//  Created by Celil Çağatay Gedik on 9.07.2024.
//

import XCTest
@testable import Pinsoft_WeatherApp

final class PWWeatherDetailViewModelTests: XCTestCase {
    var sut: PWWeatherDetailViewModel!
    var favoritesViewModel: PWFavoritesViewModel!
    var service: MockCoreDataStack!
    
    override func setUp() {
        super.setUp()
        service = MockCoreDataStack()
        favoritesViewModel = PWFavoritesViewModel(coreDataStack: service)
        let forecast1 = Forecast(date: "2024-07-08", temperature: 25.0, weatherDescription: "Sunny", humidity: 60, windSpeed: 10.0)
        let forecast2 = Forecast(date: "2024-07-09", temperature: 26.0, weatherDescription: "Cloudy", humidity: 65, windSpeed: 12.0)
        let weather = Weather(id: 1, city: "TestCity", country: "TestCountry", latitude: 40.7128, longitude: -74.0060, temperature: 25.0, weatherDescription: "Sunny", humidity: 60, windSpeed: 10.0, forecast: [forecast1, forecast2], isFavorite: false)
        sut = PWWeatherDetailViewModel(weather: weather, favoritesViewModel: favoritesViewModel)
    }
    
    override func tearDown() {
        service.deleteAllWeatherData()
        sut = nil
        favoritesViewModel = nil
        service = nil
        super.tearDown()
    }
    
    func testInit() {
        XCTAssertTrue(sut.favoritesViewModel === favoritesViewModel)
    }
    
    func testCity() {
        XCTAssertEqual(sut.city, "TestCity")
    }
    
    func testCountry() {
        XCTAssertEqual(sut.country, "TestCountry")
    }
    
    func testTemperature() {
        XCTAssertEqual(sut.temperature, "25.0°C")
    }
    
    func testWeatherDescription() {
        XCTAssertEqual(sut.weatherDescription, "Sunny")
    }
    
    func testHumidity() {
        XCTAssertEqual(sut.humidity, "60%")
    }
    
    func testWindSpeed() {
        XCTAssertEqual(sut.windSpeed, "10.0KM/H")
    }
    
    func testForecast() {
        let forecast = sut.forecast
        XCTAssertEqual(forecast.count, 2)
        XCTAssertEqual(forecast[0].date, "2024-07-08")
        XCTAssertEqual(forecast[1].date, "2024-07-09")
    }
    
    func testToggleFavorite() {
        sut.toggleFavorite()
        XCTAssertTrue(sut.isFavorite)
        XCTAssertEqual(favoritesViewModel.getFavorites().count, 1)
        XCTAssertEqual(favoritesViewModel.getFavorites().first?.city, "TestCity")
        
        sut.toggleFavorite()
        XCTAssertFalse(sut.isFavorite)
        XCTAssertEqual(favoritesViewModel.getFavorites().count, 0)
    }
}
