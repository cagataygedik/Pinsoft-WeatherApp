//
//  ForecastEntity+CoreDataProperties.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 2.07.2024.
//
//

import Foundation
import CoreData


extension ForecastEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ForecastEntity> {
        return NSFetchRequest<ForecastEntity>(entityName: "ForecastEntity")
    }

    @NSManaged public var date: String?
    @NSManaged public var temperature: Double
    @NSManaged public var weatherDescription: String?
    @NSManaged public var humidity: Int64
    @NSManaged public var windSpeed: Double
    @NSManaged public var weather: WeatherEntity?

}

extension ForecastEntity : Identifiable {

}
