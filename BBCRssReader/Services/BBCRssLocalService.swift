//
//  BBCRssLocalService.swift
//  BBCRssReader
//
//  Created by Artem Kalinovsky on 4/9/19.
//  Copyright © 2019 DataArt. All rights reserved.
//

import Foundation

final class BBCRssLocalService: RssLocalService {

    private let coreDataStack: CoreDataStack

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    func save() {
        coreDataStack.save()
    }

    func fetchRss(completion: @escaping ([RssNewsItem]?, Error?) -> Void) {
        completion(coreDataStack.fetch(RssNewsItem.self), nil)
    }

}
