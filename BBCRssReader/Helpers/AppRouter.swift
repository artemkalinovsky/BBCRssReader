//
//  AppRouter.swift
//  BBCRssReader
//
//  Created by Artem Kalinovsky on 4/10/19.
//  Copyright © 2019 DataArt. All rights reserved.
//

import ReSwift

enum RoutingDestination: String {
    case rssItemsFeed = "RssItemsFeedViewController"
    case rssItemDetails = "RssItemDetailsViewController"
}

final class AppRouter {

    let navigationController: UINavigationController

    init(window: UIWindow) {
        navigationController = UINavigationController()
        window.rootViewController = navigationController
        store.subscribe(self) {
            $0.select {
                $0.routingState
            }
        }
    }

    fileprivate func pushViewController(identifier: String, animated: Bool) {
        let viewController = instantiateViewController(identifier: identifier)
        let newViewControllerType = type(of: viewController)
        if let currentVc = navigationController.topViewController {
            let currentViewControllerType = type(of: currentVc)
            if currentViewControllerType == newViewControllerType {
                return
            }
        }

        navigationController.pushViewController(viewController, animated: animated)
    }

    private func instantiateViewController(identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
}

// MARK: - StoreSubscriber
extension AppRouter: StoreSubscriber {
    typealias StoreSubscriberStateType = RoutingState

    func newState(state: StoreSubscriberStateType) {
        let shouldAnimate = navigationController.topViewController != nil
        pushViewController(identifier: state.navigationState.rawValue, animated: shouldAnimate)
    }
}

