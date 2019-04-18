//
//  RssNewsItemFactory.swift
//  BBCRssReader
//
//  Created by Artem Kalinovsky on 4/9/19.
//  Copyright © 2019 DataArt. All rights reserved.
//

import Foundation
import CoreData
import SWXMLHash

struct RssItemFactory {

    private let coreDataStack: CoreDataStack

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    func convert(xmlIndexers: [XMLIndexer]) -> [RssNewsItem] {
        coreDataStack.writeContext.reset()
        coreDataStack.viewContext.reset()
        return xmlIndexers.map { createRssItem(from: $0) }
    }

    func createRssItem(from xmlIndexer: XMLIndexer) -> RssNewsItem {
        let rssItem = RssNewsItem(context: coreDataStack.writeContext)
        rssItem.title = xmlIndexer["title"].element?.text
        rssItem.summary = xmlIndexer["description"].element?.text
        rssItem.url = URL(string: xmlIndexer["link"].element?.text ?? "")
        rssItem.mediaUrl = URL(string: xmlIndexer["media:thumbnail"].element?.allAttributes["url"]?.text ?? "")
        rssItem.publishDate = DateFormatters.rssPublishDateFormatter.date(from: xmlIndexer["pubDate"].element?.text ?? "")
        return rssItem
    }
}
