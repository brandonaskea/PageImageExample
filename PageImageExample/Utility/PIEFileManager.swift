//
//  PIEFileManager.swift
//  PageImageExample
//
//  Created by Brandon Askea on 2/17/19.
//  Copyright © 2019 Brandon Askea. All rights reserved.
//

import Foundation

struct PIEFileManager {

    static func documentsDirectory() -> URL {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        return urls.first!
    }
    
    static func deleteFileWithID(_ id: String) -> Bool {
        let path = PIEFileManager.filePathForContentWithID(id)
        do {
            try FileManager.default.removeItem(at: path)
            return true
        } catch let error { print(error.localizedDescription); return false }
    }
    
    static func filePathForContentWithID(_ id: String) -> URL {
        var path = PIEFileManager.documentsDirectory()
        path.appendPathComponent(id)
        path.appendPathExtension("jpeg")
        return path
    }
    
    static func getJSONFile(isGood: Bool) -> [String: AnyObject] {
        var resource = "bad"
        if isGood {
            resource = "good"
        }
        if let path = Bundle.main.path(forResource: resource, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let json = json as? [String: AnyObject] {
                    return json
                }
            } catch {
                return [:]
            }
        }
        return [:]
    }
}
