//
//  CatalogAPITest.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 22/11/25.
//

import XCTest

@testable import Digidentity

final class CatalogAPITest: XCTestCase {

    var sut: CatalogAPI?

    override func setUp() {
        super.setUp()
        sut = .items(sinceId: nil, maxId: nil)
    }

    func testSUTExist() {
        XCTAssertNotNil(sut)
    }

    func testItemsEndpoint() {
        XCTAssertEqual(sut?.baseURL, "https://marlove.net/e/mock/v1")
        XCTAssertEqual(sut?.path, "/items")
        XCTAssertEqual(sut?.method, .get)
        XCTAssertNil(sut?.headers)
        XCTAssertNil(sut?.queryItems)
    }
}
