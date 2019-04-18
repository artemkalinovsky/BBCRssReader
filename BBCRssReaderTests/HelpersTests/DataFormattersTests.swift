//
//  DataFormattersTests.swift
//  BBCRssReaderTests
//
//  Created by Artem Kalinovsky on 4/18/19.
//  Copyright © 2019 DataArt. All rights reserved.
//

import XCTest
@testable import BBCRssReader

final class DataFormattersTests: XCTestCase {

    func testRssPublishDateFormatter() {
        let dateString = "Thu, 18 Apr 2019 11:36:41 GMT"
        let rssPublishDateFormatter = DateFormatters.rssPublishDateFormatter

        guard let date = rssPublishDateFormatter.date(from: dateString) else {
            XCTFail("Date should not be nil.")
            return
        }

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(abbreviation: "GMT")!
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let weekDay = calendar.component(.weekday, from: date)

        XCTAssertEqual(weekDay, 5)
        XCTAssertEqual(day, 18)
        XCTAssertEqual(month, 4)
        XCTAssertEqual(year, 2019)
        XCTAssertEqual(hour, 11)
        XCTAssertEqual(minutes, 36)
        XCTAssertEqual(seconds, 41)
    }

}
