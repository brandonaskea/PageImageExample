//
//  PIEFileManager.swift
//  PageImageExample
//
//  Created by Brandon Askea on 2/17/19.
//  Copyright © 2019 Brandon Askea. All rights reserved.
//

import UIKit

struct PIEFileManager {

    public static func documentsDirectory() -> URL {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        return urls.first!
    }
    
    public static func deleteFileWithID(_ id: String) -> Bool {
        let filePath = PIEFileManager.filePathForContentWithID(id)
        do {
            try FileManager.default.removeItem(at: filePath)
            return true
        } catch let error { print(error.localizedDescription); return false }
    }
    
    public static func store(image: UIImage, for id: String) {
        let filePath = PIEFileManager.filePathForContentWithID(id)
        let imageData = image.jpegData(compressionQuality: 1.0)
        if         FileManager.default.createFile(atPath: filePath.path, contents: imageData, attributes: nil) {
            print("Created File \(id)")
        }

    }
    
    public static func filePathForContentWithID(_ id: String) -> URL {
        var path = PIEFileManager.documentsDirectory()
        path.appendPathComponent(id)
        path.appendPathExtension("jpeg")
        return path
    }
}
