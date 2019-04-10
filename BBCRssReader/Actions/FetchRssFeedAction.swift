//
//  FetchRssFeedAction.swift
//  BBCRssReader
//
//  Created by Artem Kalinovsky on 4/10/19.
//  Copyright © 2019 DataArt. All rights reserved.
//

import ReSwift

func fetchRssFeed(state: AppState, store: Store<AppState>) -> FetchRssFeedAction {
    state.rssServicesState.rssRemoteService.fetchRss { rssNewsItems, error in
        store.dispatch(SetRssFeedAction(rssFeedItems: rssNewsItems ?? []))
    }
    return FetchRssFeedAction()
}

struct FetchRssFeedAction: Action {
    
}

