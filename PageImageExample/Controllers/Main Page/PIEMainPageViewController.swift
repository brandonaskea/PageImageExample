//
//  PIEMainPageViewController.swift
//  PageImageExample
//
//  Created by Brandon Askea on 2/16/19.
//  Copyright © 2019 Brandon Askea. All rights reserved.
//

import UIKit

class PIEMainPageViewController: UIPageViewController {
    
    var content:[PIEContent] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        PIENetworkManager().downloadImageContent { (errorMessage, content) in
            if let errorMessage = errorMessage {
                self.presentAlertWith(errorMessage)
            }
            else {
                self.content = content
            }
        }
    }
    
    func presentAlertWith(_ errorMessage: String) {
        let alert = UIAlertController(title: nil, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }

}
