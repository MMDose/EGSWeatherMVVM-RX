//
//  WeatherObject.swift
//  EGSTaskWeather
//
//  Created by Dose on 12/27/20.
//

import UIKit
import CoreData

@objc(WeatherEntity)
public class WeatherEntity: NSManagedObject, Managed {
    static var entityName: String { return "WeatherEntity" }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherEntity> {
        return NSFetchRequest<WeatherEntity>(entityName: "WeatherEntity")
    }
    
    @NSManaged var weatherData: Data
    @NSManaged var locality: String
    
    /// Find or create new WeatherEntity in managedObjectContext. 
    /// - Parameters:
    ///   - context: Find or create in context
    ///   - weatherData: Weather data to store
    ///   - locality: Locality to store
    @discardableResult
    static func findOrCreate(into context: NSManagedObjectContext, weatherData: Data, locality: String) -> WeatherEntity {
        
        let weatherObjsect: WeatherEntity = WeatherEntity.findOrCreate(in: context)
        weatherObjsect.weatherData = weatherData
        weatherObjsect.locality = locality
        
        return weatherObjsect
        
    }
}


