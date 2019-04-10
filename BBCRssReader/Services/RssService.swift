//
//  RssService.swift
//  BBCRssReader
//
//  Created by Artem Kalinovsky on 4/9/19.
//  Copyright © 2019 DataArt. All rights reserved.
//

import Foundation

protocol RssService {
    func fetchRss(completion: @escaping ([RssNewsItem]?, Error?) -> Void)
}

protocol RssRemoteService: RssService {
    var sourceUrlLink: String { get }
}

protocol RssLocalService: RssService {
    func save()
}
