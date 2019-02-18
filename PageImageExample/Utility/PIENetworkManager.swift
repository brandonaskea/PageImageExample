//
//  PIENetworkManager.swift
//  PageImageExample
//
//  Created by Brandon Askea on 2/17/19.
//  Copyright © 2019 Brandon Askea. All rights reserved.
//

import UIKit

let urlString = "https://api.flickr.com/services/feeds/photos_public.gne?format=json" + "&nojsoncallback=1"
let contentDownloadErrorMessage = "There was an error downloading content."
let jsonPrefix = "jsonFlickrFeed"

class PIENetworkManager: NSObject {
    
    public func downloadImageContent(completion: @escaping (_ errorMessage: String?, _ content: [PIEContent]) -> Void) {
        /*
            Downloads the metadata to parse
            out each PIEContent object. If
            there is an error the completion
            returns an option message.
         */
        guard let url = URL(string: urlString) else { completion(contentDownloadErrorMessage, []); return }
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let json = self.jsonFrom(data)
                completion(nil, PIEContentParser().parse(json))
            }
            else {
                completion(error?.localizedDescription ?? contentDownloadErrorMessage, [])
            }
            
        }.resume()
    }
    
    private func jsonFrom(_ data: Data) -> [String: Any] {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else { return [:] }
            return json
        }
        catch let error {
            print("Error | \(error.localizedDescription)")
            return [:]
        }
    }

}
