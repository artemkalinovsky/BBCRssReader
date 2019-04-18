//
//  CoreDataStackTests.swift
//  BBCRssReaderTests
//
//  Created by Artem Kalinovsky on 4/18/19.
//  Copyright © 2019 DataArt. All rights reserved.
//

import XCTest
@testable import BBCRssReader

final class CoreDataStackTests: XCTestCase {

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

    func testViewContextIsSavedAfterAddingNewRssNewsItem() {
        guard let writeContext = coreDataStack?.writeContext else {
            XCTFail("Write ManagaedObjectContext should not be nil.")
            return
        }

        guard let viewContext = coreDataStack?.viewContext else {
             XCTFail("View ManagaedObjectContext should not be nil.")
            return
        }

        expectation(forNotification: .NSManagedObjectContextDidSave,
                    object: viewContext) { (notification) -> Bool in
                        return true
        }

        let rssNewsItem = RssNewsItem(context: writeContext)
        rssNewsItem.title = "Test Title"
        rssNewsItem.summary = "Test Summary"

        coreDataStack?.save()

        waitForExpectations(timeout: 5.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }
    }

    func testFetchAllRssNewsFeedItems() {
        guard let writeContext = coreDataStack?.writeContext else {
            XCTFail("Write ManagaedObjectContext should not be nil.")
            return
        }
        guard let viewContext = coreDataStack?.viewContext else {
            XCTFail("View ManagaedObjectContext should not be nil.")
            return
        }

        let rssNewsItem = RssNewsItem(context: writeContext)
        rssNewsItem.title = "Test Title"
        rssNewsItem.summary = "Test Summary"

        expectation(forNotification: .NSManagedObjectContextDidSave,
                    object: viewContext) { [weak self] (notification) -> Bool in
                        let allRssNewsFeedItems = self?.coreDataStack?.fetch(RssNewsItem.self) ?? []
                        XCTAssertTrue(allRssNewsFeedItems.count == 1)
                        return true
        }

        coreDataStack?.save()

        waitForExpectations(timeout: 5.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }
    }

    func testFetchRssNewsFeedItemsWithPredicate() {
        guard let writeContext = coreDataStack?.writeContext else {
            XCTFail("Write ManagaedObjectContext should not be nil.")
            return
        }
        guard let viewContext = coreDataStack?.viewContext else {
            XCTFail("View ManagaedObjectContext should not be nil.")
            return
        }

        let rssNewsItem1 = RssNewsItem(context: writeContext)
        rssNewsItem1.title = "Test Title1"
        rssNewsItem1.summary = "Test Summary1"

        let rssNewsItem2 = RssNewsItem(context: writeContext)
        rssNewsItem2.title = "Test Title2"
        rssNewsItem2.summary = "Test Summary2"

        expectation(forNotification: .NSManagedObjectContextDidSave,
                    object: viewContext) { [weak self] (notification) -> Bool in
                        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", "1")
                        let allRssNewsFeedItems = self?.coreDataStack?.fetch(RssNewsItem.self,
                                                                             predicate: predicate) ?? []
                        XCTAssertTrue(allRssNewsFeedItems.count == 1)
                        return true
        }

        coreDataStack?.save()

        waitForExpectations(timeout: 5.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }
    }

    func testFetchRssNewsFeedItemsWithLimit() {
        guard let writeContext = coreDataStack?.writeContext else {
            XCTFail("Write ManagaedObjectContext should not be nil.")
            return
        }
        guard let viewContext = coreDataStack?.viewContext else {
            XCTFail("View ManagaedObjectContext should not be nil.")
            return
        }

        let rssNewsItem1 = RssNewsItem(context: writeContext)
        rssNewsItem1.title = "Test Title1"
        rssNewsItem1.summary = "Test Summary1"

        let rssNewsItem2 = RssNewsItem(context: writeContext)
        rssNewsItem2.title = "Test Title2"
        rssNewsItem2.summary = "Test Summary2"

        expectation(forNotification: .NSManagedObjectContextDidSave,
                    object: viewContext) { [weak self] (notification) -> Bool in
                        let allRssNewsFeedItems = self?.coreDataStack?.fetch(RssNewsItem.self,
                                                                             fetchLimit: 1) ?? []
                        XCTAssertTrue(allRssNewsFeedItems.count == 1)
                        return true
        }

        coreDataStack?.save()

        waitForExpectations(timeout: 5.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }
    }

}
