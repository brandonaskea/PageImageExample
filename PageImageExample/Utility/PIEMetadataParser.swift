//
//  PIEMetadataParser.swift
//  PageImageExample
//
//  Created by Brandon Askea on 2/18/19.
//  Copyright © 2019 Brandon Askea. All rights reserved.
//

import Foundation

private let contentKeyItems = "items"
private let contentKeyTitle = "title"
private let contentKeyMedia = "media"
private let contentKeyAuth  = "author_id"
private let contentKeyLink  = "link"
private let contentKeyURL   = "m"

private let contentIDBridge = "~"

struct PIEMetadataParser {
    public func parseJSON(_ data: Data) -> [PIEMetadata] {
        let json = jsonFrom(data)
        guard let items:[[String: AnyObject]] = json[contentKeyItems] as? [[String: AnyObject]] else { return [] }
        var contents:[PIEMetadata] = []
        for i in items {
            guard let media = i[contentKeyMedia] as? [String: AnyObject],
            let url = media[contentKeyURL] as? String,
            let title = i[contentKeyTitle] as? String,
            let authorID = i[contentKeyAuth] as? String,
            let link = i[contentKeyLink] as? String,
            let linkURL = URL(string: link)
            else { continue }
            let id = authorID + contentIDBridge + linkURL.lastPathComponent // ID = authorID~linkID
            let content:PIEMetadata = PIEMetadata.findOrCreateWithID(id, title: title, url: url)
            contents.append(content)
        }
        return contents
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
