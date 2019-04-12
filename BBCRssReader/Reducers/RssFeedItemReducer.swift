//
//  RssFeedItemReducer.swift
//  BBCRssReader
//
//  Created by Artem Kalinovsky on 4/12/19.
//  Copyright © 2019 DataArt. All rights reserved.
//

import ReSwift

func rssFeedItemDetailsReducer(action: Action, state: RssFeedItemDetailsState?) -> RssFeedItemDetailsState {
    var state = state ?? RssFeedItemDetailsState(rssItem: nil)
    if let routingAction = action as? RoutingAction {
        state.rssItem = routingAction.detailedRssNewsFeedItem
    }
    return state
}
