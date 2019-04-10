//
//  RoutingState.swift
//  BBCRssReader
//
//  Created by Artem Kalinovsky on 4/10/19.
//  Copyright © 2019 DataArt. All rights reserved.
//

import ReSwift

struct RoutingState: StateType {
    var navigationState: RoutingDestination

    init(navigationState: RoutingDestination = .rssItemsFeed) {
        self.navigationState = navigationState
    }
}
