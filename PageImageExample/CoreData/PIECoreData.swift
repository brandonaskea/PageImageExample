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
    
    static let instance = PIECoreData()
    
    // MARK: Static Methods
    
    class func insert<T>(type: NSManagedObject.Type) -> T {
        return NSEntityDescription.insertNewObject(forEntityName: "\(type.self)", into: PIECoreData.instance.managedObjectContext) as! T
    }
    
    class func delete(managedObject: NSManagedObject) {
        PIECoreData.instance.managedObjectContext.delete(managedObject)
    }
    
    class func get<T>(type: NSManagedObject.Type, withID id: String) -> T? {
        let context = PIECoreData.instance.managedObjectContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "\(type)")
        request.predicate = NSPredicate(format: "(id CONTAINS[c] %@)", id)
        let fetch = try? context.fetch(request)
        return fetch?.first as? T
    }
    
    class func save() {
        let context = PIECoreData.instance.managedObjectContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print("Core Data error: \(error)")
            }
        }
    }
    
    // MARK: Core Data Stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "PageImageExample")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "PageImageExample", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = PIEFileManager.documentsDirectory().appendingPathComponent("PageImageExampleCoreData.sqlite")
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        
        NotificationCenter.default.addObserver(self, selector: #selector(mergeChanges), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
        return managedObjectContext
    }()
    
    @objc func updateMainContext(notification: NSNotification){
        self.managedObjectContext.mergeChanges(fromContextDidSave: notification as Notification)
    }
    
    @objc func mergeChanges(notification: NSNotification){
        if (notification.object as! NSManagedObjectContext != self.managedObjectContext) {
            self.performSelector(onMainThread: #selector(updateMainContext), with: notification, waitUntilDone: false)
        }
        
    }
    
}
