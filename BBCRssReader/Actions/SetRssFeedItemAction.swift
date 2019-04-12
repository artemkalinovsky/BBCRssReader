//
//  SetRssFeedItemAction.swift
//  BBCRssReader
//
//  Created by Artem Kalinovsky on 4/12/19.
//  Copyright © 2019 DataArt. All rights reserved.
//

import ReSwift

func setRssFeedItem(state: AppState, store: Store<AppState>) -> SetRssFeedItemAction {
    return SetRssFeedItemAction(rssNewsItem: state.rssFeedItemDetailsState.rssItem)
}

struct SetRssFeedItemAction: Action {
    var rssNewsItem: RssNewsItem?
}
