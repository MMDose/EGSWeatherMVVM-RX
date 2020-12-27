//
//  CoreDataStackMock.swift
//  EGSTaskWeatherTests
//
//  Created by Dose on 12/27/20.
//

import UIKit
import CoreData

@testable import EGSTaskWeather

/// CoreData Stack Mock. Creates NSPersistentContainer in memory. 
final class CoreDataStackMock: CoreDataStackProtocol {
    static var modelName: String = "WeatherModel"
    
    lazy var storeContainer: NSPersistentContainer = {
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType

        let container = NSPersistentContainer(
          name: CoreDataStack.modelName)
        container.persistentStoreDescriptions = [persistentStoreDescription]

        container.loadPersistentStores { _, error in
          if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
          }
        }
        return container
    }()
    
    
}
