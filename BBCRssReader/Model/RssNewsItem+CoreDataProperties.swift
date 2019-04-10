//
//  RssNewsItem+CoreDataProperties.swift
//  BBCRssReader
//
//  Created by Artem Kalinovsky on 4/9/19.
//  Copyright © 2019 DataArt. All rights reserved.
//
//

import Foundation
import CoreData


extension RssNewsItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RssNewsItem> {
        return NSFetchRequest<RssNewsItem>(entityName: "RssNewsItem")
    }

    @NSManaged public var title: String?
    @NSManaged public var summary: String?
    @NSManaged public var publishDate: Date?
    @NSManaged public var url: URL?
    @NSManaged public var mediaUrl: URL?

}
