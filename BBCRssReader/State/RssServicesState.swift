//
//  RssServicesState.swift
//  BBCRssReader
//
//  Created by Artem Kalinovsky on 4/10/19.
//  Copyright © 2019 DataArt. All rights reserved.
//

import ReSwift

struct RssServicesState: StateType {

    let coreDataStack: CoreDataStack
    let rssRemoteService: RssRemoteService
    let rssLocalService: RssLocalService

    init() {
        let coreDataStack = CoreDataStack(modelName: "BBCRssReaderCoreDataModel")
        self.coreDataStack = coreDataStack
        self.rssRemoteService = BBCRssRemoteService(rssItemFactory: RssItemFactory(coreDataStack: coreDataStack))
        self.rssLocalService = BBCRssLocalService()
    }
}
