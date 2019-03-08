//
//  PIENetworkManager.swift
//  PageImageExample
//
//  Created by Brandon Askea on 2/17/19.
//  Copyright © 2019 Brandon Askea. All rights reserved.
//

import UIKit

private let urlString = "https://api.flickr.com/services/feeds/photos_public.gne?format=json" + "&nojsoncallback=1"
private let contentDownloadErrorMessage = "There was an error downloading content."

class PIENetworkManager: NSObject {
    
    public func downloadImageAt(_ url: URL, completion: @escaping (_ errorMessage: String?, _ image: UIImage?) -> Void) {
        /*
            Downloads the image from the
            URL asynronously and sends
            the result in the completion
            callback on the main thread.
        */
        DispatchQueue.global().async {
            do {
                let imageData = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let image = UIImage(data: imageData) {
                        completion(nil, image)
                    }
                    else {
                        completion(contentDownloadErrorMessage, nil)
                    }
                }
            }
            catch let error {
                DispatchQueue.main.async {
                    completion(error.localizedDescription, nil)
                }
            }
        }
    }
    
    public func downloadImageMetadata(completion: @escaping (_ errorMessage: String?, _ metadata: [PIEMetadata]) -> Void) {
        /*
            Downloads the metadata to parse
            out each PIEContent object. If
            there is an error the completion
            returns an option message.
         */
        guard let url = URL(string: urlString) else { completion(contentDownloadErrorMessage, []); return }
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data {
                    completion(nil, PIEMetadataParser().parseJSON(data))
                    
                }
                else {
                    completion(error?.localizedDescription ?? contentDownloadErrorMessage, [])
                }
            }
        }.resume()
    }

}
