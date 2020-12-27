//
//  NSManagedConext+Extensions.swift
//  EGSTaskWeather
//
//  Created by Dose on 12/27/20.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
    /// Insert new object into EntityDescription
    /// - Returns: Inserted object.
    func insertObject<A: NSManagedObject>() -> A where A: Managed {
        guard let object = NSEntityDescription.insertNewObject(forEntityName: A.entityName, into: self) as? A else { fatalError("Wrong object type")}
        return object
    }
}

extension NSManagedObjectContext {
    /// Save context changes ro rollBack
    /// - Returns: reuslt of save proccessing.
    @discardableResult
    public func saveOrRollBack() -> Bool {
        do {
            try save()
            return true
        } catch {
            rollback()
            return false
        }
    }
    
    /// Calls saveOrRollBack after block execution.
    public func performChanges(_ block: @escaping ()->()) {
        block()
        saveOrRollBack()
    }
}
