//
//  PWFavoritesViewModelTests.swift
//  Pinsoft-WeatherAppTests
//
//  Created by Celil Çağatay Gedik on 8.07.2024.
//

import XCTest
import CoreData
@testable import Pinsoft_WeatherApp

final class MockCoreDataStack: CoreDataStackConformable {
    var favoriteWeathers: [Weather] = []
    
    func saveFavoriteWeatherData(_ weather: Weather) { // Pinsoft_WeatherApp.Weather
        favoriteWeathers.append(weather)
    }
    
    func removeFavoriteWeatherData(_ weather: Weather) { //Pinsoft_WeatherApp.Weather
        favoriteWeathers.removeAll { $0.id == weather.id }
    }
    
    func fetchFavoriteWeatherData() -> [Pinsoft_WeatherApp.WeatherEntity] {
        return favoriteWeathers.map { weather in
            let entity = WeatherEntity(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
            entity.id = Int64(weather.id)
            entity.city = weather.city
            entity.country = weather.country
            entity.latitude = weather.latitude
            entity.longitude = weather.longitude
            entity.temperature = weather.temperature
            entity.weatherDescription = weather.weatherDescription
            entity.humidity = Int64(weather.humidity)
            entity.windSpeed = weather.windSpeed
            entity.isFavorite = weather.isFavorite
            return entity
        }
    }
    
    func deleteAllWeatherData() {
        favoriteWeathers.removeAll()
    }
}


final class PWFavoritesViewModelTests: XCTestCase {
    var sut: PWFavoritesViewModel!
    var service: MockCoreDataStack!
    
    override func setUp() {
        super.setUp()
        service = MockCoreDataStack()
        sut = PWFavoritesViewModel(coreDataStack: service)
        sut.updateUI = nil // Reset the updateUI closure to avoid unintended reuse
    }
    
    override func tearDown() {
        service.deleteAllWeatherData()
        sut = nil
        service = nil
        super.tearDown()
    }
    
    func testViewModelInit() {
        XCTAssertEqual(sut.filteredFavorites.count, 0)
    }
    
    func testAddFavorite() {
        let weather = Weather(id: 1, city: "TestCity", country: "TestCountry", latitude: 40.7128, longitude: -74.0060, temperature: 25.0, weatherDescription: "Sunny", humidity: 60, windSpeed: 10.0, forecast: [], isFavorite: false)
        
        let expectation = XCTestExpectation(description: "Favorite added")
        sut.updateUI = {
            XCTAssertEqual(self.sut.getFavorites().count, 1)
            XCTAssertEqual(self.sut.getFavorites().first?.city, "TestCity")
            expectation.fulfill()
        }
        
        sut.addFavorite(weather)
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testRemoveFavorite() {
        let weather = Weather(id: 1, city: "TestCity", country: "TestCountry", latitude: 40.7128, longitude: -74.0060, temperature: 25.0, weatherDescription: "Sunny", humidity: 60, windSpeed: 10.0, forecast: [], isFavorite: false)
        
        sut.addFavorite(weather)
        
        let expectation = XCTestExpectation(description: "Favorite removed")
        sut.updateUI = {
            XCTAssertEqual(self.sut.getFavorites().count, 0)
            expectation.fulfill()
        }
        
        sut.removeFavorite(weather)
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testIsFavorite() {
        let weather = Weather(id: 1, city: "TestCity", country: "TestCountry", latitude: 40.7128, longitude: -74.0060, temperature: 25.0, weatherDescription: "Sunny", humidity: 60, windSpeed: 10.0, forecast: [], isFavorite: false)
        
        sut.addFavorite(weather)
        
        XCTAssertTrue(sut.isFavorite(weather))
        
        sut.removeFavorite(weather)
        
        XCTAssertFalse(sut.isFavorite(weather))
    }
    
    func testFilterFavorites() {
        let weather1 = Weather(id: 1, city: "New York", country: "USA", latitude: 40.7128, longitude: -74.0060, temperature: 25.0, weatherDescription: "Sunny", humidity: 60, windSpeed: 10.0, forecast: [], isFavorite: false)
        let weather2 = Weather(id: 2, city: "Los Angeles", country: "USA", latitude: 34.0522, longitude: -118.2437, temperature: 20.0, weatherDescription: "Cloudy", humidity: 70, windSpeed: 5.0, forecast: [], isFavorite: false)
        
        sut.addFavorite(weather1)
        sut.addFavorite(weather2)
        
        sut.filterFavorites(by: "New")
        XCTAssertEqual(sut.filteredFavorites.count, 1)
        XCTAssertEqual(sut.filteredFavorites.first?.city, "New York")
        
        sut.filterFavorites(by: "Los")
        XCTAssertEqual(sut.filteredFavorites.count, 1)
        XCTAssertEqual(sut.filteredFavorites.first?.city, "Los Angeles")
        
        sut.filterFavorites(by: "")
        XCTAssertEqual(sut.filteredFavorites.count, 2)
    }
}
