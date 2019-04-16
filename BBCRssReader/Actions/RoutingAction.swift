//
//  RoutingAction.swift
//  BBCRssReader
//
//  Created by Artem Kalinovsky on 4/12/19.
//  Copyright © 2019 DataArt. All rights reserved.
//

import ReSwift

struct RoutingAction: Action {
    let destination: RoutingDestination
    let detailedRssNewsFeedItem: RssNewsItem?

    init(destination: RoutingDestination, detailedRssNewsFeedItem: RssNewsItem? = nil) {
        self.destination = destination
        self.detailedRssNewsFeedItem = detailedRssNewsFeedItem
    }
}

