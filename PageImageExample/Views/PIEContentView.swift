//
//  PIEContentView.swift
//  PageImageExample
//
//  Created by Brandon Askea on 2/18/19.
//  Copyright © 2019 Brandon Askea. All rights reserved.
//

import UIKit

let contentViewErrorMessage = "There was an error downloading the content."

protocol PIEContentViewDelegate {
    func present(_ alert: UIAlertController)
}

class PIEContentView: UIView {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var delegate: PIEContentViewDelegate!
    
    func load(content: PIEContent) {
        
        titleLabel.text = content.title
        
        guard let id = content.id
        else { self.presentAlert(); return }
        
        if content.isDownloaded {
            let filePath = PIEFileManager.filePathForContentWithID(id)
            let image = UIImage(contentsOfFile: filePath.path)
            contentImageView.image = image
        }
        else {
            activityIndicator.isHidden = false
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            guard let contentURL = content.url,
            let url = URL(string: contentURL)
            else { self.presentAlert(); activityIndicator.stopAnimating(); return }
            DispatchQueue.global().async {
                do {
                    let imageData = try Data(contentsOf: url)
                    DispatchQueue.main.async {
                        if let image = UIImage(data: imageData) {
                            PIEFileManager.store(image: image, for: id)
                            content.isDownloaded = true
                            PIECoreData.save()
                            self.contentImageView.image = image
                            self.activityIndicator.stopAnimating()
                        }
                        else {
                            self.presentAlert()
                            self.activityIndicator.stopAnimating()
                        }
                    }
                }
                catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func presentAlert() {
        let alert = UIAlertController(title: nil, message: contentViewErrorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
        }))
        delegate.present(alert)
    }
}
