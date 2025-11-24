//
//  CatalogBuilderTests.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 22/11/25.
//

import SwiftData
import XCTest

@testable import Digidentity

@MainActor
final class CatalogBuilderTests: XCTestCase {
    var modelContainer: ModelContainer!

    override func setUpWithError() throws {
        try super.setUpWithError()
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        modelContainer = try ModelContainer(for: ItemEntity.self, configurations: config)
    }

    func testBuildWithDefaults() async {
        // Given
        let builder = await CatalogBuilder(modelContainer: modelContainer)

        // When
        let viewController = builder.build()

        // Then
        XCTAssertNotNil(viewController)
    }

    func testBuildWithRemoteRepository() async {
        // Given
        let mockRepository = MockRemoteCatalogRepository()
        mockRepository.result = .success([])
        let builder = await CatalogBuilder(modelContainer: modelContainer)
            .withRemoteRepository(mockRepository)

        // When
        let viewController = builder.build()

        // Then
        XCTAssertNotNil(viewController)
    }

    func testBuildWithLocalRepository() async {
        // Given
        let mockRepository = MockLocalCatalogRepository()
        let builder = await CatalogBuilder(modelContainer: modelContainer)
            .withLocalRepository(mockRepository)

        // When
        let viewController = builder.build()

        // Then
        XCTAssertNotNil(viewController)
    }

    func testBuildWithCustomUseCase() async {
        // Given
        let mockUseCase = MockGetCatalogUseCase()
        let builder = await CatalogBuilder(modelContainer: modelContainer)
            .withUseCase(mockUseCase)

        // Act
        let viewController = builder.build()

        // Assert
        XCTAssertNotNil(viewController)
    }

    func testBuildWithCustomDelegate() async {
        // Given
        let mockDelegate = MockCatalogViewModelDelegate()
        let builder = await CatalogBuilder(modelContainer: modelContainer)
            .withDelegate(mockDelegate)

        // Act
        let viewController = builder.build()

        // Assert
        XCTAssertNotNil(viewController)
    }
}
