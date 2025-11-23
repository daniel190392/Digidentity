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
    var sut: CatalogViewModel?
    var mockUseCase = MockGetCatalogUseCase()
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        sut = CatalogViewModel(getCatalogUseCase: mockUseCase)
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
            XCTAssertEqual(message, "La URL es inválida")
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
            XCTAssertEqual(message, "Respuesta del servidor: 500")
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
            XCTAssertTrue(message.contains("Error al decodificar"))
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
            XCTAssertTrue(message.contains("Error de red"))
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
            XCTAssertEqual(message, "La URL es inválida")
        } else {
            XCTFail("State should be .error")
        }
    }
}
