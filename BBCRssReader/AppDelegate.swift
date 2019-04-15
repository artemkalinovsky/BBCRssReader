//
//  AppDelegate.swift
//  BBCRssReader
//
//  Created by Artem Kalinovsky on 4/8/19.
//  Copyright © 2019 DataArt. All rights reserved.
//

import ReSwift

let store = Store<AppState>(reducer: appReducer, state: nil, middleware: [createMiddleware(fetchRssFeed())])

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let appRouter = AppRouter()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        return true
    }

}

