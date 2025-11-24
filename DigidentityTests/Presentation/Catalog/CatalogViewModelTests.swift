//
//  CatalogViewModelTests.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 22/11/25.
//

import Combine
import XCTest

@testable import Digidentity

@MainActor
final class CatalogViewModelTests: XCTestCase {
    private enum Constants {
        static let badUrl = "We cannot reach the server. Please try again later."
        static let badServerResponse = "There was a problem with the server. Please try again later."
        static let decodingError = "We received unexpected data from the server. Please try again later."
        static let networkError = "There was a network problem. Check your connection and try again."
        static let databaseError = "We could not access local data. Please try again later."
    }

    var sut: CatalogViewModel?
    var mockUseCase = MockGetCatalogUseCase()
    var mockDelegate = MockCatalogViewModelDelegate()

    override func setUp() {
        super.setUp()
        sut = CatalogViewModel(getCatalogUseCase: mockUseCase)
        sut?.delegate = mockDelegate
    }

    func testLoadCatalogSuccess() async {
        // Given
        let expectedItems = [Item(id: "1", text: "123", confidence: 10.0, image: "image")]
        mockUseCase.resultToReturn = .success(expectedItems)

        // When
        await sut?.loadCatalog()

        // Then
        if case .loaded(let items) = sut?.state {
            XCTAssertTrue(mockUseCase.executeWasCalled)
            XCTAssertEqual(items.count, expectedItems.count)
            XCTAssertEqual(items.first?.id, expectedItems.first?.id)
        } else {
            XCTFail("State should be .loaded")
        }
    }

    func testLoadNextPageSuccessAppendsItems() async {
        // Given
        let expectedItems = [
            Item(id: "1", text: "123", confidence: 10.0, image: "image"),
            Item(id: "2", text: "456", confidence: 10.0, image: "image")
        ]
        mockUseCase.resultToReturn = .success(expectedItems)
        await sut?.loadCatalog()
        mockUseCase.resultToReturn = .success([Item(id: "3", text: "789", confidence: 10.0, image: "image")])

        // When
        await sut?.loadNextPage()

        // Then
        if case .loaded(let items) = sut?.state {
            XCTAssertTrue(mockUseCase.executeWasCalled)
            XCTAssertEqual(mockUseCase.maxId, "2")
            XCTAssertEqual(mockUseCase.executeCountCalled, 2)
            XCTAssertEqual(items.count, expectedItems.count + 1)
        } else {
            XCTFail("State should be .loaded")
        }
    }

    func testLoadNextPageSuccessWithEmptyItems() async {
        // Given
        let expectedItems = [
            Item(id: "1", text: "123", confidence: 10.0, image: "image"),
            Item(id: "2", text: "456", confidence: 10.0, image: "image")
        ]
        mockUseCase.resultToReturn = .success(expectedItems)
        await sut?.loadCatalog()
        mockUseCase.resultToReturn = .success([])

        // When
        await sut?.loadNextPage()
        await sut?.loadNextPage()

        // Then
        if case .loaded(let items) = sut?.state {
            XCTAssertTrue(mockUseCase.executeWasCalled)
            XCTAssertEqual(mockUseCase.executeCountCalled, 2)
            XCTAssertEqual(items.count, expectedItems.count)
        } else {
            XCTFail("State should be .loaded")
        }
    }

    func testLoadCatalogErrorBadURL() async {
        // Given
        mockUseCase.resultToReturn = .failure(.badURL)

        // When
        await sut?.loadCatalog()

        // Then
        if case .error(let message) = sut?.state {
            XCTAssertEqual(message, Constants.badUrl)
        } else {
            XCTFail("State should be .error")
        }
    }

    func testLoadCatalogErrorBadServerResponse() async {
        // Given
        mockUseCase.resultToReturn = .failure(.badServerResponse(statusCode: 500))

        // When
        await sut?.loadCatalog()

        // Then
        if case .error(let message) = sut?.state {
            XCTAssertEqual(message, Constants.badServerResponse)
        } else {
            XCTFail("State should be .error")
        }
    }

    func testLoadCatalogErrorDecodingError() async {
        // Given
        let underlyingError = NSError(domain: "test", code: 0)
        mockUseCase.resultToReturn = .failure(.decodingError(underlying: underlyingError))

        // When
        await sut?.loadCatalog()

        // Then
        if case .error(let message) = sut?.state {
            XCTAssertTrue(message.contains(Constants.decodingError))
        } else {
            XCTFail("State should be .error")
        }
    }

    func testLoadCatalogErrorNetworkError() async {
        // Given
        let underlyingError = NSError(domain: "network", code: -1009)
        mockUseCase.resultToReturn = .failure(.networkError(underlying: underlyingError))

        // When
        await sut?.loadCatalog()

        // Then
        if case .error(let message) = sut?.state {
            XCTAssertTrue(message.contains(Constants.networkError))
        } else {
            XCTFail("State should be .error")
        }
    }

    func testLoadCatalogErrorDatabaseError() async {
        // Given
        let underlyingError = NSError(domain: "database", code: -1009)
        mockUseCase.resultToReturn = .failure(.databaseError(underlying: underlyingError))

        // When
        await sut?.loadCatalog()

        // Then
        if case .error(let message) = sut?.state {
            XCTAssertTrue(message.contains(Constants.databaseError))
        } else {
            XCTFail("State should be .error")
        }
    }

    func testLoadNextPageFailure() async {
        // Given
        let expectedItems = [
            Item(id: "1", text: "123", confidence: 10.0, image: "image"),
            Item(id: "2", text: "456", confidence: 10.0, image: "image")
        ]
        mockUseCase.resultToReturn = .success(expectedItems)
        await sut?.loadCatalog()
        mockUseCase.resultToReturn = .failure(.badURL)

        // When
        await sut?.loadNextPage()

        // Then
        if case .error(let message) = sut?.state {
            XCTAssertEqual(message, Constants.badUrl)
        } else {
            XCTFail("State should be .error")
        }
    }

    func testSelectItem() async {
        // Given
        let expectedItems = [
            Item(id: "1", text: "123", confidence: 10.0, image: "image"),
            Item(id: "2", text: "456", confidence: 10.0, image: "image")
        ]
        mockUseCase.resultToReturn = .success(expectedItems)
        await sut?.loadCatalog()

        // When
        sut?.selectItem(at: 0)

        // Then
        XCTAssertTrue(mockDelegate.navigateToItemWasCalled)
        XCTAssertEqual(mockDelegate.item?.id, "1")
    }

    func testLoadCatalogSendsLoadingAndLoadedStatesToListener() async {
        // Given
        let expectedItems = [
            Item(id: "1", text: "123", confidence: 10.0, image: "image"),
            Item(id: "2", text: "456", confidence: 10.0, image: "image")
        ]
        mockUseCase.resultToReturn = .success(expectedItems)
        let loadingExpectation = XCTestExpectation(description: "loading")
        let loadedExpectation = XCTestExpectation(description: ".loaded")
        var receivedStates: [CatalogViewModel.CatalogViewState] = []

        sut?.bind { state in
            receivedStates.append(state)
            switch state {
            case .loading:
                loadingExpectation.fulfill()
            case .loaded(let items):
                XCTAssertEqual(items.count, expectedItems.count)
                loadedExpectation.fulfill()
            default:
                break
            }
        }

        // When
        await sut?.loadCatalog()

        // Then
        await fulfillment(of: [loadingExpectation, loadedExpectation], timeout: 1.0)
        XCTAssertEqual(receivedStates.count, 2)
    }

    func testUpdateWithNewItemsSuccessfull() async {
        // Given
        let initialItems = [Item(id: "2", text: "123", confidence: 10.0, image: "image")]
        mockUseCase.resultToReturn = .success(initialItems)
        await sut?.loadCatalog()
        let newItems = [Item(id: "1", text: "1", confidence: 0.0, image: "image")]
        mockUseCase.resultToReturn = .success(newItems)

        // When
        await sut?.updateWithNewItems()

        // Then
        XCTAssertEqual(mockUseCase.executeCountCalled, 2)
        XCTAssertEqual(mockUseCase.sinceId, "2")
        XCTAssertNil(mockUseCase.maxId)

        if case .loaded(let loadedItems) = sut?.state {
            XCTAssertEqual(loadedItems.count, 2)
        } else {
            XCTFail("State should be success")
        }
    }

    func testUpdateWithNewItemsHandlesDuplicatesItems() async {
        // Given
        let initialItems = [Item(id: "1", text: "2", confidence: 10.0, image: "image")]
        mockUseCase.resultToReturn = .success(initialItems)
        await sut?.loadCatalog()
        let newItems = [Item(id: "1", text: "1", confidence: 0.0, image: "image")]
        mockUseCase.resultToReturn = .success(newItems)

        // When
        await sut?.updateWithNewItems()

        // Then
        XCTAssertEqual(mockUseCase.executeCountCalled, 2)
        XCTAssertEqual(mockUseCase.sinceId, "1")
        XCTAssertNil(mockUseCase.maxId)

        if case .loaded(let loadedItems) = sut?.state {
            XCTAssertEqual(loadedItems.count, 1)
        } else {
            XCTFail("State should be success")
        }
    }
}
