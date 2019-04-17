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

    func fetchRss(searchString: String? = nil, limit: Int? = nil, completion: @escaping ([RssNewsItem]?, Error?) -> Void) {
        var predicate: NSPredicate? = nil
        if let searchString = searchString {
            predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchString)
        }
        completion(coreDataStack.fetch(RssNewsItem.self, predicate: predicate, fetchBatchSize: limit), nil)
    }

}
