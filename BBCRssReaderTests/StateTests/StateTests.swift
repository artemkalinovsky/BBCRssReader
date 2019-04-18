//
//  StateTests.swift
//  BBCRssReaderTests
//
//  Created by Artem Kalinovsky on 4/18/19.
//  Copyright © 2019 DataArt. All rights reserved.
//

import XCTest
@testable import BBCRssReader

final class StateTests: XCTestCase {

    var coreDataStack: CoreDataStack?

    private var rssNewsItem: RssNewsItem? {
        guard let writeContext = coreDataStack?.writeContext else {
            return nil
        }
        let rssNewsItem = RssNewsItem(context: writeContext)
        return rssNewsItem
    }

    override func setUp() {
        coreDataStack = CoreDataStack(modelName: "BBCRssReaderCoreDataModel", persistentStoreType: .inMemory)
    }

    override func tearDown() {
        coreDataStack = nil
    }

    func testInitialState() {
        XCTAssertTrue(store.state.routingState.navigationState == .rssItemsFeed)
    }

    func testMovingToRssNewsItemDetailsState() {
        guard let rssNewsItem = rssNewsItem else {
            XCTFail("RssNewsItem should not be nil.")
            return
        }
        store.dispatch(RoutingAction(destination: .rssItemDetails, detailedRssNewsFeedItem: rssNewsItem))

        XCTAssertTrue(store.state.routingState.navigationState == .rssItemDetails)
        XCTAssertTrue(store.state.rssFeedItemDetailsState.rssItem == rssNewsItem)
    }

    func testMovingToSafariViewController() {
        guard let rssNewsItem = rssNewsItem else {
            XCTFail("RssNewsItem should not be nil.")
            return
        }

        store.dispatch(RoutingAction(destination: .rssItemsFeed))

        XCTAssertNil(store.state.rssFeedItemDetailsState.rssItem)

        store.dispatch(RoutingAction(destination: .rssItemDetails, detailedRssNewsFeedItem: rssNewsItem))
        store.dispatch(RoutingAction(destination: .safariViewController))

        XCTAssertTrue(store.state.routingState.navigationState == .safariViewController)
        XCTAssertTrue(store.state.rssFeedItemDetailsState.rssItem == rssNewsItem)
    }

    func testMovingToZoomedPhotoView() {
        guard let rssNewsItem = rssNewsItem else {
            XCTFail("RssNewsItem should not be nil.")
            return
        }

        store.dispatch(RoutingAction(destination: .rssItemsFeed))

        XCTAssertNil(store.state.rssFeedItemDetailsState.rssItem)

        store.dispatch(RoutingAction(destination: .zoomedImage, detailedRssNewsFeedItem: rssNewsItem))

        XCTAssertTrue(store.state.routingState.navigationState == .zoomedImage)
        XCTAssertTrue(store.state.rssFeedItemDetailsState.rssItem == rssNewsItem)
    }

}
