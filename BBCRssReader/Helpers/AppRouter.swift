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

    init() {
        store.subscribe(self) {
            $0.select {
                $0.routingState
            }
        }
    }

    fileprivate func pushViewController(identifier: String, animated: Bool) {
        guard let navigationController = (getVisibleViewController() as? UITabBarController)?.selectedViewController as? UINavigationController else { return }
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

    private func getVisibleViewController(_ rootViewController: UIViewController? = nil) -> UIViewController? {
        let rootVC = rootViewController ?? UIApplication.shared.keyWindow?.rootViewController
        guard let presentedViewController = rootVC?.presentedViewController else {
            return rootVC
        }
        if let navigationController = presentedViewController as? UINavigationController,
            let lastViewController = navigationController.viewControllers.last {
            return lastViewController
        }
        if let tabBarController = presentedViewController as? UITabBarController,
            let selectedViewController = tabBarController.selectedViewController {
            return selectedViewController
        }
        return getVisibleViewController(presentedViewController)
    }
}

// MARK: - StoreSubscriber
extension AppRouter: StoreSubscriber {
    typealias StoreSubscriberStateType = RoutingState

    func newState(state: RoutingState) {
        pushViewController(identifier: state.navigationState.rawValue, animated: true)
    }
}

