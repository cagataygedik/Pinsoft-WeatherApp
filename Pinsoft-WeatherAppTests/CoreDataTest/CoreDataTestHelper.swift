//
//  CoreDataTestHelper.swift
//  Pinsoft-WeatherAppTests
//
//  Created by Celil Çağatay Gedik on 30.07.2024.
//

import CoreData
@testable import Pinsoft_WeatherApp

class CoreDataTestHelper {
    static func createMockPersistanceContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "Pinsoft_WeatherApp")
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { (description, error) in
            if let error = error as NSError? {
                fatalError("failed to load \(error)")
            }
        }
        return container
    }
}
