//
//  Managed.swift
//  EGSTaskWeather
//
//  Created by Dose on 12/27/20.
//

import UIKit
import CoreData

protocol Managed: class, NSFetchRequestResult {
    /// NSManagedObjects entity name
    static var entityName: String { get }
}

extension Managed {
    
    /// Sorted fetch request for Context fetch.
    static var sortedFetchRequest: NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>.init(entityName: entityName)
        return request
    }
    
}

extension Managed where Self: NSManagedObject {
    static var entityName: String {
        return entity().name!
    }
    
    /// Fetchs Managed object in context.
    /// - Parameters:
    ///   - context: NSManagedObjects context.
    ///   - configurationBlock: Condifurations for NSManagedObject.
    static func fetch(in context: NSManagedObjectContext, configurationBlock: (NSFetchRequest<Self>)->() = {_ in} ) -> [Self] {
        let request = NSFetchRequest<Self>.init(entityName: Self.entityName)
        configurationBlock(request)
        return try! context.fetch(request)
        
    }
    
    /// Fetchs ManagedObjects in context registeredObjects(raw cache)
    /// - Parameter context: NSManagedObject context
    static func materializedObject(in context: NSManagedObjectContext) -> Self? {
        for object in context.registeredObjects {
            guard let result = object as? Self else { continue }
            return result
        }
        return nil
    }
    
    /// Find managed object from contextRegisteredObjects or fetch from context.
    static func findOrFetch(in context: NSManagedObjectContext) -> Self? {
        guard let object = materializedObject(in: context) else {
            return fetch(in: context) { (request) in
                request.returnsObjectsAsFaults = false
                request.fetchLimit = 1
            }.first
        }
        
        return object

    }
    
    /// Finds/Fetchs managed object in context and raw cache, if not exist creaetes one.
    static func findOrCreate(in context: NSManagedObjectContext) -> Self {
        guard let object = findOrFetch(in: context) else {
            let newObject: Self = context.insertObject()
            return newObject
        }
        return object
    }

}
