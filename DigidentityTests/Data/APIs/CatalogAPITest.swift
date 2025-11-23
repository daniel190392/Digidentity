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

    func testSUTExist() {
        sut = .items(sinceId: nil, maxId: nil)
        XCTAssertNotNil(sut)
    }

    func testItemsEndpoint() {
        sut = .items(sinceId: nil, maxId: nil)
        XCTAssertEqual(sut?.baseURL, "https://marlove.net/e/mock/v1")
        XCTAssertEqual(sut?.path, "/items")
        XCTAssertEqual(sut?.method, .get)
        XCTAssertNil(sut?.headers)
        XCTAssertNil(sut?.queryItems)
    }

    func testItemsEndpointWithParameters() {
        sut = .items(sinceId: "1", maxId: "2")
        XCTAssertEqual(sut?.baseURL, "https://marlove.net/e/mock/v1")
        XCTAssertEqual(sut?.path, "/items")
        XCTAssertEqual(sut?.method, .get)
        XCTAssertNil(sut?.headers)
        XCTAssertEqual(sut?.queryItems?.count, 2)
    }
}
