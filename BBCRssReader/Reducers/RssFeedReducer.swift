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
    switch(action) {
    case _ as FetchRssFeedAction:
        state = RssFeedState(rssItems: [], showLoading: true)
    case let setRssFeedAction as SetRssFeedAction:
        state.rssItems = setRssFeedAction.rssFeedItems
        state.showLoading = false
    default: break
    }
    return state
}
