//
//  PIEContentView.swift
//  PageImageExample
//
//  Created by Brandon Askea on 2/18/19.
//  Copyright © 2019 Brandon Askea. All rights reserved.
//

import UIKit

class PIEContentView: UIView {

    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func load(content: PIEContent) {
        
        titleLabel.text = content.title
        
        guard let id = content.id else { return }
        
        if content.isDownloaded {
            let filePath = PIEFileManager.filePathForContentWithID(id)
            let image = UIImage(contentsOfFile: filePath.path)
            contentImageView.image = image
        }
        else {
            
        }
        
    }
    
}
