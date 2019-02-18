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
        let container = NSPersistentContainer(name: "PageImageExample")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
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
