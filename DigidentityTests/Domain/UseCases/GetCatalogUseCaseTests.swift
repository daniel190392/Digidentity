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
    var mockRemoteRepository = MockRemoteCatalogRepository()
    var mockLocalRepository = MockLocalCatalogRepository()
    var mockNetworkChecking = MockNetworkChecking()

    override func setUp() {
        super.setUp()
        sut = DefaultGetCatalogUseCase(remoteRepository: mockRemoteRepository,
                                       localRepository: mockLocalRepository,
                                       networkChecker: mockNetworkChecking)
    }

    func testUseCaseSuccess() async {
        // Given
        mockRemoteRepository.result = .success([])

        // When
        let result = await sut?.execute(sinceId: nil, maxId: nil)

        // Then
        switch result {
        case .success(let items):
            XCTAssertTrue(mockRemoteRepository.getCatalogWasCalled)
            XCTAssertEqual(items.count, 0)
        case .failure:
            XCTFail("Expected success but got failure")
        case .none:
            XCTFail("Expected success")
        }
    }

    func testUseCaseSuccessWithLocalData() async {
        // Given
        mockNetworkChecking.isConnected = false
        try? await mockLocalRepository.save(items: [])

        // When
        let result = await sut?.execute(sinceId: nil, maxId: nil)
        let saveItemsWasCalled = await mockLocalRepository.saveItemsWasCalled
        let getCatalogWasCalled = await mockLocalRepository.getCatalogWasCalled

        // Then
        switch result {
        case .success(let items):
            XCTAssertTrue(saveItemsWasCalled)
            XCTAssertTrue(getCatalogWasCalled)
            XCTAssertEqual(items.count, 0)
        case .failure:
            XCTFail("Expected success but got failure")
        case .none:
            XCTFail("Expected success")
        }
    }

    func testUseCaseError() async {
        // Given
        mockRemoteRepository.result = .failure(APIError.badURL)

        // When
        let result = await sut?.execute(sinceId: nil, maxId: nil)

        // Then
        switch result {
        case .success:
            XCTFail("Expected failure")
        case .failure(let error):
            XCTAssertTrue(mockRemoteRepository.getCatalogWasCalled)
            XCTAssertNotNil(error)
        case .none:
            XCTFail("Expected failure")
        }
    }
}
