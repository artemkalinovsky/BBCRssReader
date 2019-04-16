//
//  RssFeedAction.swift
//  BBCRssReader
//
//  Created by Artem Kalinovsky on 4/15/19.
//  Copyright © 2019 DataArt. All rights reserved.
//

import ReSwift

enum RssFeedAction: Action {
    case fetch
    case search(String)
    case set(Loadable<[RssNewsItem]>)
}
