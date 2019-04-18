//
//  RssNewsItemFactoryTests.swift
//  BBCRssReaderTests
//
//  Created by Artem Kalinovsky on 4/18/19.
//  Copyright © 2019 DataArt. All rights reserved.
//

import XCTest
import SWXMLHash
@testable import BBCRssReader

final class RssNewsItemFactoryTests: XCTestCase {

    var coreDataStack: CoreDataStack?
    var rssItemFactory: RssItemFactory?

    override func setUp() {
        coreDataStack = CoreDataStack(modelName: "BBCRssReaderCoreDataModel", persistentStoreType: .inMemory)
        rssItemFactory = RssItemFactory(coreDataStack: coreDataStack!)
    }

    override func tearDown() {
        coreDataStack = nil
        rssItemFactory = nil
    }

    func testRssNewsItemCreationFromXml() {
        guard let localXmlFileUrl = Bundle(for: type(of: self)).url(forResource: "OneRssItemXml", withExtension: "xml") else {
            XCTFail("Local .xml file url should not be nil.")
            return
        }
        guard let localXmlFileData = try? Data(contentsOf: localXmlFileUrl) else {
            XCTFail("Data of local .xml file url should not be nil.")
            return
        }

        let rssXml = SWXMLHash.parse(localXmlFileData)

        XCTAssertNotNil(rssXml["rss"]["channel"]["item"].all.first!)
        XCTAssertTrue(rssXml["rss"]["channel"]["item"].all.count == 1)

        let parsedRssNewsItem = rssItemFactory?.createRssItem(from: rssXml["rss"]["channel"]["item"].all.first!)

        XCTAssertTrue(parsedRssNewsItem?.title == "Facebook bans UK far right groups and leaders")
        XCTAssertTrue(parsedRssNewsItem?.summary == "A dozen named groups and individuals will be purged from the social network, it said.")
        XCTAssertTrue(parsedRssNewsItem?.url == URL(string: "https://www.bbc.co.uk/news/technology-47974579"))
        XCTAssertTrue(parsedRssNewsItem?.mediaUrl == URL(string: "http://c.files.bbci.co.uk/B90A/production/_106507374_mediaitem106507371.jpg"))
    }

    func testRssNewsItemsArrayCreationFromXml() {
        guard let localXmlFileUrl = Bundle(for: type(of: self)).url(forResource: "RssItems", withExtension: "xml") else {
            XCTFail("Local .xml file url should not be nil.")
            return
        }
        guard let localXmlFileData = try? Data(contentsOf: localXmlFileUrl) else {
            XCTFail("Data of local .xml file url should not be nil.")
            return
        }

        let rssXml = SWXMLHash.parse(localXmlFileData)
        let parsedRssNewsItems = rssItemFactory?.convert(xmlIndexers: rssXml["rss"]["channel"]["item"].all) ?? []

        XCTAssertTrue(parsedRssNewsItems.count == rssXml["rss"]["channel"]["item"].all.count)
    }

}
