//
//  AppState.swift
//  BBCRssReader
//
//  Created by Artem Kalinovsky on 4/10/19.
//  Copyright © 2019 DataArt. All rights reserved.
//

import ReSwift

struct AppState: StateType {
    let rssServicesState: RssServicesState
    let routingState: RoutingState
    let rssFeedState: RssFeedState
    let rssFeedItemDetailsState: RssFeedItemDetailsState
}
