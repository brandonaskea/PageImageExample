//
//  PIEMetadataExtension.swift
//  PageImageExample
//
//  Created by Brandon Askea on 2/18/19.
//  Copyright © 2019 Brandon Askea. All rights reserved.
//

import Foundation
import CoreData

extension PIEMetadata {
    
    public class func findOrCreateWithID(_ id: String, title: String, url: String) -> PIEMetadata {
        /*
            If there is already content downloaded
            stored for the id then retreive the
            cached PIEContent, if not, then create.
        */
        var content: PIEMetadata!
        if let foundContent:PIEMetadata = PIECoreData.get(type: PIEMetadata.self, withID: id) {
            content = foundContent
        }
        else {
            let createdContent:PIEMetadata = PIECoreData.insert(type: PIEMetadata.self)
            createdContent.id = id
            createdContent.title = title
            createdContent.url = url
            content = createdContent
        }
        return content
    }
    
    public func delete() {
        guard let id = self.id else { return }
        if PIEFileManager.deleteFileWithID(id) {
            print("Deleted File \(id)")
        }
        PIECoreData.delete(managedObject: self)
    }
    
}
