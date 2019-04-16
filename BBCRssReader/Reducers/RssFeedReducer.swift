//
//  RssFeedReducer.swift
//  BBCRssReader
//
//  Created by Artem Kalinovsky on 4/10/19.
//  Copyright © 2019 DataArt. All rights reserved.
//

import ReSwift

func rssFeedReducer(action: Action, state: RssFeedState?) -> RssFeedState {
    var state = state ?? RssFeedState(rssItems: [], showLoading: false)

    guard let rssFeedAction = action as? RssFeedAction else {
        return state
    }

    switch rssFeedAction {
    case .fetch, .set(.loading):
         state = RssFeedState(rssItems: [], showLoading: true)
    case .set( .value(let rssItems)):
        state.rssItems = rssItems
        state.showLoading = false
    case .search(let searchQuery):
        state.rssItems = state.rssItems.filter {
            ($0.title?.contains(searchQuery) ?? false) || ($0.summary?.contains(searchQuery) ?? false)
        }
    default: break
    }

    return state
}
