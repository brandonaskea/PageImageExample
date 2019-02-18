//
//  PIEContentParser.swift
//  PageImageExample
//
//  Created by Brandon Askea on 2/18/19.
//  Copyright © 2019 Brandon Askea. All rights reserved.
//

import Foundation

let contentKeyItems = "items"
let contentKeyTitle = "title"
let contentKeyMedia = "media"
let contentKeyAuth  = "author_id"
let contentKeyLink  = "link"
let contentKeyURL   = "m"

let contentIDBridge = "~"

struct PIEContentParser {
    func parse(_ json: [String: Any]) -> [PIEContent] {
        guard let items:[[String: AnyObject]] = json[contentKeyItems] as? [[String: AnyObject]] else { return [] }
        var contents:[PIEContent] = []
        for i in items {
            guard let media = i[contentKeyMedia] as? [String: AnyObject],
            let url = media[contentKeyURL] as? String,
            let title = i[contentKeyTitle] as? String,
            let authorID = i[contentKeyAuth] as? String,
            let link = i[contentKeyLink] as? String,
            let linkURL = URL(string: link)
            else { continue }
            let id = authorID + contentIDBridge + linkURL.lastPathComponent
            let content:PIEContent = PIEContent.findOrCreateWithID(id, title: title, url: url)
            contents.append(content)
        }
        return contents
    }
}
