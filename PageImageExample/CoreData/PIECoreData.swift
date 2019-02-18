//
//  PIECoreData.swift
//  PageImageExample
//
//  Created by Brandon Askea on 2/17/19.
//  Copyright © 2019 Brandon Askea. All rights reserved.
//

import UIKit
import CoreData

class PIECoreData: NSObject {
    
    class func insert<T>(type: NSManagedObject.Type) -> T {
        return NSEntityDescription.insertNewObject(forEntityName: "\(type.self)", into: PIECoreData.managedObjectContext()) as! T
    }
    
    class func delete(managedObject: NSManagedObject) {
        PIECoreData.managedObjectContext().delete(managedObject)
    }
    
    class func get<T>(type: NSManagedObject.Type, withID id: String) -> T? {
        let context = PIECoreData.managedObjectContext()
        let request = NSFetchRequest<NSManagedObject>(entityName: "\(type)")
        request.predicate = NSPredicate(format: "(id CONTAINS[c] %@)", id)
        let fetch = try? context.fetch(request)
        return fetch?.first as? T
    }
    
    class func save() {
        let context = PIECoreData.managedObjectContext()
        do {
            try context.save()
        } catch let error {
            print("Core Data error: \(error)")
        }
    }
    
    class func managedObjectContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let moc = appDelegate.managedObjectContext
        return moc
    }
    
}
