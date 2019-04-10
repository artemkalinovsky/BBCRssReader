//
//  RssFeedState.swift
//  BBCRssReader
//
//  Created by Artem Kalinovsky on 4/10/19.
//  Copyright © 2019 DataArt. All rights reserved.
//

import ReSwift

struct RssFeedState: StateType {
    var rssItems: [RssNewsItem]
    var showLoading: Bool
}
