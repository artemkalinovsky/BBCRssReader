//
//  DateFormatters.swift
//  BBCRssReader
//
//  Created by Artem Kalinovsky on 4/9/19.
//  Copyright © 2019 DataArt. All rights reserved.
//

import Foundation

struct DateFormatters {

    static let rssPublishDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        return dateFormatter
    }()

}
