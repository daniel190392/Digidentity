//
//  CatalogBuilderTests.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 22/11/25.
//

import XCTest

@testable import Digidentity

@MainActor
final class CatalogBuilderTests: XCTestCase {
    func testBuildWithDefaults() {
        // Given
        let builder = CatalogBuilder()

        // When
        let viewController = builder.build()

        // Then
        XCTAssertNotNil(viewController)
    }

    func testBuildWithCustomRepository() {
        // Given
        let mockRepository = MockCatalogRepository()
        mockRepository.result = .success([])
        let builder = CatalogBuilder()
            .withRepository(mockRepository)

        // When
        let viewController = builder.build()

        // Then
        XCTAssertNotNil(viewController)
    }

    func testBuildWithCustomUseCase() {
        // Given
        let mockUseCase = MockGetCatalogUseCase()
        let builder = CatalogBuilder()
            .withUseCase(mockUseCase)

        // Act
        let viewController = builder.build()

        // Assert
        XCTAssertNotNil(viewController)
    }

    func testBuildWithCustomDelegate() {
        // Given
        let mockDelegate = MockCatalogViewModelDelegate()
        let builder = CatalogBuilder()
            .withDelegate(mockDelegate)

        // Act
        let viewController = builder.build()

        // Assert
        XCTAssertNotNil(viewController)
    }
}
