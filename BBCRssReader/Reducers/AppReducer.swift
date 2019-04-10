//
//  AppReducer.swift
//  BBCRssReader
//
//  Created by Artem Kalinovsky on 4/10/19.
//  Copyright © 2019 DataArt. All rights reserved.
//

import ReSwift

func appReducer(action: Action, state: AppState?) -> AppState {
    return AppState(rssServicesState: rssServicesResucer(action: action, state: state?.rssServicesState),
                    routingState: routingReducer(action: action, state: state?.routingState),
                    rssFeedState: rssFeedReducer(action: action, state: state?.rssFeedState))
}
