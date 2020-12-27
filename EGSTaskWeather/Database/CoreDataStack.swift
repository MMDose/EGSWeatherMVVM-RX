//
//  CoreDataStack.swift
//  EGSTaskWeather
//
//  Created by Dose on 12/27/20.
//

import UIKit
import CoreData


//MARK: - CoreDataStackProtocol

protocol CoreDataStackProtocol {
    /// CoreData models name.
    static var modelName: String { get }
    
    /// NSPersistentContainer
    var storeContainer: NSPersistentContainer { get }
    
}


//MARK: - CoreDataStack

final class CoreDataStack: CoreDataStackProtocol {
    
    public static let modelName: String = "WeatherModel"
    
    public lazy var storeContainer: NSPersistentContainer = {
      let container = NSPersistentContainer(name: CoreDataStack.modelName)
      container.loadPersistentStores { _, error in
        if let error = error as NSError? {
          fatalError("Unresolved error \(error), \(error.userInfo)")
        }
      }
      return container
    }()
}
