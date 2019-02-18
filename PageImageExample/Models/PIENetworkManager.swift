//
//  PIENetworkManager.swift
//  PageImageExample
//
//  Created by Brandon Askea on 2/17/19.
//  Copyright © 2019 Brandon Askea. All rights reserved.
//

import UIKit

let urlString = "https://api.flickr.com/services/feeds/photos_public.gne?format=json"
let contentDownloadErrorMessage = "There was an error downloading content."

class PIENetworkManager: NSObject {
    
    func downloadImageContent(completion: @escaping (_ errorMessage: String?, _ content: [PIEContent]) -> Void) {
        guard let url = URL(string: urlString) else { completion(contentDownloadErrorMessage, []); return }
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { (data, response, error) in
            if let err = error {
                completion(err.localizedDescription, [])
            }
            else {
                completion(nil, [])
            }
        }.resume()
    }

}
