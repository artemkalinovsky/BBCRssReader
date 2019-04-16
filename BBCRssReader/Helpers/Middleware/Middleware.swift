//
//  Middleware.swift
//  BBCRssReader
//
//  Created by Artem Kalinovsky on 4/15/19.
//  Copyright © 2019 DataArt. All rights reserved.
//

import ReSwift

typealias Middleware = SimpleMiddleware<AppState>

func fetchRssFeed() -> Middleware {
     return { fetchRssFeed(action: $0, context: $1) }
}

private func fetchRssFeed(action: Action, context: MiddlewareContext<AppState>) -> Action? {

    guard let rssFeedAction = action as? RssFeedAction else {
        return action
    }

    switch rssFeedAction {
    case .fetch:
        context.state?.rssServicesState.rssRemoteService.fetchRss(searchString: nil) { rssNewsItems, error in
            var state: Loadable<[RssNewsItem]>
            if let error = error {
                state = .error(error)
            } else {
                state = .value(rssNewsItems ?? [])
            }
            context.state?.rssServicesState.rssLocalService.save()
            context.dispatch(RssFeedAction.set(state))
        }
        return RssFeedAction.set(.loading)
    case .search(let searchString):
        context.state?.rssServicesState.rssLocalService.fetchRss(searchString: searchString) { rssNewsItems, error in
            var state: Loadable<[RssNewsItem]>
            if let error = error {
                state = .error(error)
            } else {
                state = .value(rssNewsItems ?? [])
            }
            context.dispatch(RssFeedAction.set(state))
        }
        return nil
    default:
        return action
    }
}

