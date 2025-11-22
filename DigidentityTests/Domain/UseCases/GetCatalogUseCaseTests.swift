//
//  GetCatalogUseCaseTests.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 22/11/25.
//

import XCTest

@testable import Digidentity

final class GetCatalogUseCaseTests: XCTestCase {
    var sut: GetCatalogUseCase?
    var mockRepository = MockCatalogRepository()

    override func setUp() {
        super.setUp()
        sut = DefaultGetCatalogUseCase(repository: mockRepository)
    }

    func testUseCaseSuccess() async {
        // Given
        mockRepository.result = .success([])

        // When
        let result = await sut?.execute()

        // Then
        switch result {
        case .success(let items):
            XCTAssertEqual(items.count, 0)
        case .failure:
            XCTFail("Expected success but got failure")
        case .none:
            XCTFail("Expected success")
        }
    }

    func testUseCaseError() async {
        // Given
        mockRepository.result = .failure(APIError.badURL)

        // When
        let result = await sut?.execute()

        // Then
        switch result {
        case .success:
            XCTFail("Expected failure")
        case .failure(let error):
            XCTAssertNotNil(error)
        case .none:
            XCTFail("Expected failure")
        }
    }
}
