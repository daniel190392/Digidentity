//
//  DefaultCatalogRepositoryTests.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 22/11/25.
//

import XCTest

@testable import Digidentity

final class DefaultCatalogRepositoryTests: XCTestCase {
    var sut: CatalogRepository?
    var mockSession = MockSession()

    override func setUp() {
        super.setUp()
        sut = DefaultCatalogRepository(session: mockSession)
    }

    func testSUT() {
        XCTAssertNotNil(sut)
    }

    func testGetCatalog_success() async {
        // Given
        let itemDTOs = [ItemDTO(id: "1", text: "Item 1", confidence: 0.9, image: "url")]
        mockSession.dataToReturn = try? JSONEncoder().encode(itemDTOs)
        mockSession.responseToReturn = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                                       statusCode: 200,
                                                       httpVersion: nil,
                                                       headerFields: nil)
        // When
        let result = await sut!.getCatalog()

        // Then
        switch result {
        case .success(let items):
            XCTAssertEqual(items.count, 1)
            XCTAssertEqual(items.first?.id, "1")
        case .failure:
            XCTFail("Expected success but got failure")
        }
    }

    func testGetCatalog_networkError() async {
        // Given
        mockSession.errorToThrow = APIError.badURL

        // When
        let result = await sut!.getCatalog()

        // Then
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            XCTAssertNotNil(error)
        }
    }

    func testGetCatalog_badServerResponse() async {
        // Given
        let itemDTOs = [ItemDTO(id: "1", text: "Item 1", confidence: 0.9, image: "url")]
        mockSession.dataToReturn = try? JSONEncoder().encode(itemDTOs)
        mockSession.responseToReturn = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                                       statusCode: 401,
                                                       httpVersion: nil,
                                                       headerFields: nil)
        // When
        let result = await sut!.getCatalog()

        // Then
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            XCTAssertNotNil(error)
        }
    }

    func testGetCatalog_decodingError() async {
        // Given
        mockSession.dataToReturn = Data()
        mockSession.responseToReturn = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                                       statusCode: 200,
                                                       httpVersion: nil,
                                                       headerFields: nil)
        // When
        let result = await sut!.getCatalog()

        // Then
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            XCTAssertNotNil(error)
        }
    }
}
