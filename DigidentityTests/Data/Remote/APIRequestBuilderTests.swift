//
//  APIRequestBuilderTests.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 22/11/25.
//

import XCTest

@testable import Digidentity

final class APIRequestBuilderTests: XCTestCase {
    let builder = APIRequestBuilder.shared

    override func setUp() {
        super.setUp()
        builder.setGlobalToken("")
    }

    func testBuildRequest_withGetEndpoint() {
        // Given
        let mockToken = "testToken"
        builder.setGlobalToken(mockToken)
        let api: MockAPIEndpoint = .getMethod

        // When
        guard let request = builder.buildRequest(for: api) else {
            XCTFail("Expected Request")
            return
        }

        // Then
        XCTAssertEqual(request.url?.absoluteString, "baseUrl/get")
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), mockToken)
    }

    func testBuildRequest_withPostEndpoint() {
        // Given
        let mockToken = "testToken"
        builder.setGlobalToken(mockToken)
        let api: MockAPIEndpoint = .postMethod

        // When
        guard let request = builder.buildRequest(for: api) else {
            XCTFail("Expected Request")
            return
        }

        // Then
        XCTAssertEqual(request.url?.absoluteString, "baseUrl/post")
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), mockToken)
        XCTAssertEqual(request.value(forHTTPHeaderField: "NewHeader"), "NewValue")
    }

    func testBuildRequest_withPutEndpoint() {
        // Given
        let mockToken = "testToken"
        builder.setGlobalToken(mockToken)
        let api: MockAPIEndpoint = .putMethod

        // When
        guard let request = builder.buildRequest(for: api) else {
            XCTFail("Expected Request")
            return
        }

        // Then
        XCTAssertEqual(request.url?.absoluteString, "baseUrl/put")
        XCTAssertEqual(request.httpMethod, "PUT")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), mockToken)
    }

    func testBuildRequest_withDeleteEndpoint() {
        // Given
        let mockToken = "testToken"
        builder.setGlobalToken(mockToken)
        let api: MockAPIEndpoint = .deleteMethod

        // When
        guard let request = builder.buildRequest(for: api) else {
            XCTFail("Expected Request")
            return
        }

        // Then
        XCTAssertEqual(request.url?.absoluteString, "baseUrl/delete")
        XCTAssertEqual(request.httpMethod, "DELETE")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), mockToken)
    }
}
