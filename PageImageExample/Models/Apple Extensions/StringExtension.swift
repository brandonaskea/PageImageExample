//
//  StringExtension.swift
//  PageImageExample
//
//  Created by Brandon Askea on 2/18/19.
//  Copyright © 2019 Brandon Askea. All rights reserved.
//

import Foundation

extension String {
    func removeHTMLTags() -> String {
        /*
            handle errors in flickr JSON, which occur from time to time
        */
        return replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil).replacingOccurrences(of: "<p>", with: "").replacingOccurrences(of: "</p>", with: "").replacingOccurrences(of: "\\", with: "").replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\t", with: "").replacingOccurrences(of: "<a href=\"", with: "").replacingOccurrences(of: "</a>", with: "").replacingOccurrences(of: "\"", with: "'")
    }
}
