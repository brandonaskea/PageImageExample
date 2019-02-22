//
//  PIEContentView.swift
//  PageImageExample
//
//  Created by Brandon Askea on 2/18/19.
//  Copyright © 2019 Brandon Askea. All rights reserved.
//

import UIKit

private let contentViewErrorMessage = "There was an error downloading the content."

protocol PIEContentViewDelegate {
    func present(_ alert: UIAlertController)
}

class PIEContentView: UIView {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var delegate: PIEContentViewDelegate!
    
    public func loadContentWith(_ metadata: PIEMetadata) {
    
        titleLabel.text = metadata.title
        
        guard let id = metadata.id
        else { self.presentAlert(); return }
        
        /*
            If there is already an image
            downloaded for this content
            then present that. If not, then
            download the image and cache it
            along with the metadata id.
        */
        if metadata.isDownloaded {
            let filePath = PIEFileManager.filePathForContentWithID(id)
            let image = UIImage(contentsOfFile: filePath.path)
            contentImageView.image = image
        }
        else {
            activityIndicator.startAnimating()
            activityIndicator.hidesWhenStopped = true
            guard let contentURL = metadata.url,
            let url = URL(string: contentURL)
            else {
                self.presentAlert()
                activityIndicator.stopAnimating()
                return
            }
            PIENetworkManager().downloadImageAt(url) { (errorMessage, image) in
                if let image = image {
                    PIEFileManager.store(image: image, for: id)
                    metadata.isDownloaded = true
                    PIECoreData.save()
                    self.contentImageView.image = image
                }
                else {
                    self.presentAlert(errorMessage)
                }
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func presentAlert(_ errorMessage: String? = contentViewErrorMessage) {
        /*
            Tell the delegate (ContentViewController)
            to present an alert that describes some
            sort of error.
        */
        let alert = UIAlertController(title: nil, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
        }))
        delegate.present(alert)
    }
}
