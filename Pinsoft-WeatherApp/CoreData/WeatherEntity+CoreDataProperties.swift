//
//  WeatherEntity+CoreDataProperties.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 2.07.2024.
//
//

import Foundation
import CoreData


extension WeatherEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherEntity> {
        return NSFetchRequest<WeatherEntity>(entityName: "WeatherEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var temperature: Double
    @NSManaged public var weatherDescription: String?
    @NSManaged public var humidity: Int64
    @NSManaged public var windSpeed: Double
    @NSManaged public var forecast: NSSet?

}

// MARK: Generated accessors for forecast
extension WeatherEntity {

    @objc(addForecastObject:)
    @NSManaged public func addToForecast(_ value: ForecastEntity)

    @objc(removeForecastObject:)
    @NSManaged public func removeFromForecast(_ value: ForecastEntity)

    @objc(addForecast:)
    @NSManaged public func addToForecast(_ values: NSSet)

    @objc(removeForecast:)
    @NSManaged public func removeFromForecast(_ values: NSSet)

}

extension WeatherEntity : Identifiable {

}
