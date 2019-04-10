//
//  BBCRssRemoteService.swift
//  BBCRssReader
//
//  Created by Artem Kalinovsky on 4/9/19.
//  Copyright © 2019 DataArt. All rights reserved.
//

import Foundation
import Alamofire
import SWXMLHash

final class BBCRssRemoteService: RssRemoteService {
    
    var sourceUrlLink: String {
        return "http://feeds.bbci.co.uk/news/rss.xml"
    }

    private let rssItemFactory: RssItemFactory

    init(rssItemFactory: RssItemFactory) {
        self.rssItemFactory = rssItemFactory
    }

    func fetchRss(completion: @escaping ([RssNewsItem]?, Error?) -> Void) {
        Alamofire.request(sourceUrlLink,
                          method: .get,
                          parameters: nil).response { [weak self] response in
                            guard let responseData = response.data else {
                                completion(nil, response.error)
                                return
                            }
                            let xml = SWXMLHash.parse(responseData)
                            let allItems = xml["rss"]["channel"]["item"].all
                            let rssNewsItems = allItems.compactMap { self?.rssItemFactory.createRssItem(from: $0) }
                            completion(rssNewsItems, nil)
        }
    }
}
