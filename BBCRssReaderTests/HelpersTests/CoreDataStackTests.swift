//
//  CoreDataStackTests.swift
//  BBCRssReaderTests
//
//  Created by Artem Kalinovsky on 4/18/19.
//  Copyright © 2019 DataArt. All rights reserved.
//

import XCTest
@testable import BBCRssReader

class CoreDataStackTests: XCTestCase {

    var coreDataStack: CoreDataStack?

    override func setUp() {
        coreDataStack = CoreDataStack(modelName: "BBCRssReaderCoreDataModel", persistentStoreType: .inMemory)
    }

    override func tearDown() {
        coreDataStack = nil
    }

    func testAddNewRssNewsItem() {
        guard let writeContext = coreDataStack?.writeContext else {
            XCTFail("Write ManagaedObjectContext should not be nil.")
            return
        }
        let testTitle = "Test Title"
        let testSummary = "Test Summary"
        let testUrl = URL(string: "http://test.com")
        let testDate = Date()

        let rssNewsItem = RssNewsItem(context: writeContext)
        rssNewsItem.title = testTitle
        rssNewsItem.publishDate = testDate
        rssNewsItem.summary = testSummary
        rssNewsItem.mediaUrl = testUrl
        rssNewsItem.url = testUrl

        XCTAssertNotNil(rssNewsItem, "RSS News Item should not be nil.")
        XCTAssertTrue(rssNewsItem.title == testTitle)
        XCTAssertTrue(rssNewsItem.summary == testSummary)
        XCTAssertNotNil(rssNewsItem.publishDate)
        if let publishDate = rssNewsItem.publishDate {
             XCTAssertTrue(publishDate.compare(testDate) == .orderedSame)
        }
        XCTAssertTrue(rssNewsItem.url == testUrl)
        XCTAssertTrue(rssNewsItem.mediaUrl == testUrl)
    }

}
