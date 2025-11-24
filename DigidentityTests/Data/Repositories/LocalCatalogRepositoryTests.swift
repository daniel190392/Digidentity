//
//  LocalCatalogRepositoryTests.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 24/11/25.
//

import SwiftData
import XCTest

@testable import Digidentity

final class LocalCatalogRepositoryTests: XCTestCase {
    var container: ModelContainer!
    var context: ModelContext!
    var repository: LocalCatalogRepository!

    override func setUp() {
        super.setUp()
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        do {
            container = try ModelContainer(for: ItemEntity.self, configurations: config)
            context = ModelContext(container)
            repository = LocalCatalogRepository(modelContainer: container)
        } catch {
            XCTFail("Failed to create in-memory ModelContainer: \(error)")
        }
    }

    override func tearDown() {
        container = nil
        context = nil
        repository = nil
        super.tearDown()
    }

    func testSaveItemsInsertsNewItems() async throws {
        // Given
        let items = [
            Item(id: "A1", text: "Hello", confidence: 0.8, image: "img1"),
            Item(id: "A2", text: "World", confidence: 0.5, image: "img2")
        ]

        // When
        try await repository.save(items: items)

        // Then
        let fetched = try context.fetch(FetchDescriptor<ItemEntity>())
        XCTAssertEqual(fetched.count, 2)
    }

    func testSaveItemsUpdateItems() async throws {
        // Given
        let original = Item(id: "A1", text: "Old", confidence: 0.1, image: "old")
        let updated = Item(id: "A1", text: "New", confidence: 0.9, image: "new")

        // When
        try await repository.save(items: [original])
        try await repository.save(items: [updated])

        // Then
        let fetched = try context.fetch(FetchDescriptor<ItemEntity>())

        XCTAssertEqual(fetched.count, 1)    // no duplicates
        XCTAssertEqual(fetched.first?.text, "New")
        XCTAssertEqual(fetched.first?.confidence, 0.9)
        XCTAssertEqual(fetched.first?.image, "new")
    }

    func testGetCatalogWithMaxId() async throws {
        // Given
        let items = (1...5).map {
            Item(id: "A\($0)", text: "T\($0)", confidence: 1, image: "")
        }

        try await repository.save(items: items)

        // When
        let result = await repository.getCatalog(sinceId: nil, maxId: "A4")

        // Then
        guard case .success(let output) = result else {
            return XCTFail("Expected success")
        }
        XCTAssertEqual(output.map(\.id), ["A3", "A2", "A1"])
    }

    func test_getCatalog_fetchLimit_appliesCorrectly() async throws {
        let items = (1...20).map {
            Item(id: "ID\($0)", text: "T\($0)", confidence: 1, image: "")
        }

        try await repository.save(items: items)

        // When
        let result = await repository.getCatalog(sinceId: nil, maxId: nil)

        // Then
        guard case .success(let batch) = result else {
            return XCTFail("Expected success")
        }
        XCTAssertEqual(batch.count, 10)
    }
}
