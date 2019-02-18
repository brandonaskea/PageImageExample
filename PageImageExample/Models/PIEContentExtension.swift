//
//  PIEContentExtension.swift
//  PageImageExample
//
//  Created by Brandon Askea on 2/18/19.
//  Copyright © 2019 Brandon Askea. All rights reserved.
//

import Foundation
import CoreData

let contentEntityName = "PIEContent"

extension PIEContent {
    
    class func getAll() -> [PIEContent] {
        let context = PIECoreData.instance.managedObjectContext
        let request = NSFetchRequest<PIEContent>(entityName: contentEntityName)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        do {
            let fetched = try context.fetch(request)
            return fetched
        }
        catch {
            return []
        }
    }
    
    class func findOrCreateWithID(_ id: String, title: String, url: String) -> PIEContent {
        var content: PIEContent!
        if let foundContent:PIEContent = PIECoreData.get(type: PIEContent.self, withID: id) {
            content = foundContent
        }
        else {
            let createdContent:PIEContent = PIECoreData.insert(type: PIEContent.self)
            createdContent.id = id
            createdContent.title = title
            createdContent.url = url
            content = createdContent
        }
        return content
    }
    
    func delete() {
        guard let id = self.id,
        let foundContent:PIEContent = PIECoreData.get(type: PIEContent.self, withID: id)
        else { return }
        if PIEFileManager.deleteFileWithID(id) {
            print("Deleted File \(id)")
        }
        PIECoreData.delete(managedObject: foundContent)
    }
    
}
