//
//  CoreDataStackTests.swift
//  Pinsoft-WeatherAppTests
//
//  Created by Celil Çağatay Gedik on 30.07.2024.
//

import XCTest
import CoreData
@testable import Pinsoft_WeatherApp

final class CoreDataStackTests: XCTestCase {
    var coreDataStack: CoreDataStack!
    var context: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataStack()
        coreDataStack.persistentContainer = CoreDataTestHelper.createMockPersistanceContainer()
        context = coreDataStack.persistentContainer.viewContext
    }
    
    override func tearDown() {
        coreDataStack = nil
        context = nil
        super.tearDown()
    }
    
    func testSaveWeatherData() {
        let weather = Weather(id: 1, city: "Burdur", country: "Turkiye", latitude: 15.0, longitude: 15.0, temperature: 25.0, weatherDescription: "Sunny", humidity: 50, windSpeed: 5.0, forecast: [], isFavorite: false)
        coreDataStack.saveWeatherData([weather])
        
        let fetchRequest: NSFetchRequest<WeatherEntity> = WeatherEntity.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            XCTAssertEqual(results.count, 1)
            XCTAssertEqual(results.first?.city, "Burdur")
            XCTAssertEqual(results.first?.temperature, 25.0)
        } catch {
            XCTFail("Failed to fetch data: \(error)")
        }
    }
    
    func testFetchWeatherData() {
        let weather = Weather(id: 1, city: "Burdur", country: "Turkiye", latitude: 15.0, longitude: 15.0, temperature: 25.0, weatherDescription: "Sunny", humidity: 50, windSpeed: 5.0, forecast: [], isFavorite: false)
        coreDataStack.saveWeatherData([weather])
        
        let fetchedData = coreDataStack.fetchWeatherData().map { $0.toWeather() }
        XCTAssertEqual(fetchedData, [weather])
    }
    
    func testDeleteAllWeatherData() {
        let weatherOne = Weather(id: 1, city: "Burdur", country: "Turkiye", latitude: 15.0, longitude: 15.0, temperature: 25.0, weatherDescription: "Sunny", humidity: 50, windSpeed: 5.0, forecast: [], isFavorite: false)
        let weatherTwo = Weather(id: 2, city: "Merkez", country: "Turkiye", latitude: 12.0, longitude: 12.0, temperature: 22.0, weatherDescription: "Clear Sky", humidity: 40, windSpeed: 3.0, forecast: [], isFavorite: false)
        coreDataStack.saveWeatherData([weatherOne, weatherTwo])
        coreDataStack.deleteAllWeatherData()
        
        let fetchedData = coreDataStack.fetchWeatherData()
        XCTAssertEqual(fetchedData.count, 0)
    }
    
    func testSaveFavoriteWeatherData() {
        let weather = Weather(id: 1, city: "Burdur", country: "Turkiye", latitude: 15.0, longitude: 15.0, temperature: 25.0, weatherDescription: "Sunny", humidity: 50, windSpeed: 5.0, forecast: [], isFavorite: false)
        coreDataStack.saveFavoriteWeatherData(weather)
        
        let fetchRequest: NSFetchRequest<WeatherEntity> = WeatherEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", 1)
        
        do {
            let results = try context.fetch(fetchRequest)
            XCTAssertEqual(results.count, 1)
            XCTAssertEqual(results.first?.isFavorite, true)
        } catch {
            XCTFail("Failed to fetch data: \(error)")
        }
    }
    
    func testRemoveFavoriteWeatherData() {
        let weather = Weather(id: 1, city: "Burdur", country: "Turkiye", latitude: 15.0, longitude: 15.0, temperature: 25.0, weatherDescription: "Sunny", humidity: 50, windSpeed: 5.0, forecast: [], isFavorite: true)
        coreDataStack.saveWeatherData([weather])
        XCTAssertEqual(weather.isFavorite, true)
        coreDataStack.removeFavoriteWeatherData(weather)
        
        let fetchRequest: NSFetchRequest<WeatherEntity> = WeatherEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", 1)
        
        do {
            let results = try context.fetch(fetchRequest)
            XCTAssertEqual(results.count, 1)
            XCTAssertEqual(results.first?.isFavorite, false)
        } catch {
            XCTFail("failed to fetch data: \(error)")
        }
    }
    
    func testUpdateWeatherWithFavorites() {
        let weatherOne = Weather(id: 1, city: "Burdur", country: "Turkiye", latitude: 15.0, longitude: 15.0, temperature: 25.0, weatherDescription: "Sunny", humidity: 50, windSpeed: 5.0, forecast: [], isFavorite: false)
        let weatherTwo = Weather(id: 2, city: "Merkez", country: "Turkiye", latitude: 12.0, longitude: 12.0, temperature: 22.0, weatherDescription: "Clear Sky", humidity: 40, windSpeed: 3.0, forecast: [], isFavorite: true)
        coreDataStack.saveWeatherData([weatherOne, weatherTwo])
        
        let updatedWeather = coreDataStack.updateWeatherWithFavorites([weatherOne, weatherTwo])
        XCTAssertEqual(updatedWeather.count, 2)
        XCTAssertEqual(updatedWeather[1].isFavorite, true)
    }
}
