//
//  PIEContentViewController.swift
//  PageImageExample
//
//  Created by Brandon Askea on 2/18/19.
//  Copyright © 2019 Brandon Askea. All rights reserved.
//

import UIKit

class PIEContentViewController: UIViewController {
    
    var content: PIEContent!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let contentView = view as? PIEContentView else { return }
        contentView.delegate = self
        contentView.load(content: content)
    }

}

extension PIEContentViewController: PIEContentViewDelegate {
    func present(_ alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
}
