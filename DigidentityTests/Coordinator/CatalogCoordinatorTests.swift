//
//  CatalogCoordinatorTests.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 23/11/25.
//

import SwiftData
import UIKit
import XCTest

@testable import Digidentity

@MainActor
final class CatalogCoordinatorTests: XCTestCase {

    var sut: CatalogCoordinator!
    var mockNavigationController: MockNavigationController!
    var container: ModelContainer!

    override func setUpWithError() throws {
        try super.setUpWithError()
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: ItemEntity.self, configurations: config)
        mockNavigationController = MockNavigationController()
        sut = CatalogCoordinator(navigationController: mockNavigationController,
                                 modelContainer: container)
    }

    func test_start_buildsViewControllerAndPushesIt() async throws {
        // Given
        let expectation = XCTestExpectation(description: "Wait view controller on the main thread")

        // When
        mockNavigationController.pushCompletion = {
            expectation.fulfill()
        }
        sut.start()

        // Then
        await fulfillment(of: [expectation], timeout: 0.1)
        XCTAssertTrue(mockNavigationController.pushedViewController is CatalogViewController)
    }

    func test_navigateToItem_pushesItemDetailViewController() async throws {
        // Given
        let dummyItem = Item(id: "1", text: "2", confidence: 3, image: "image")
        let expectation = XCTestExpectation(description: "Wait view controller on the main thread")

        // When
        mockNavigationController.pushCompletion = {
            expectation.fulfill()
        }
        sut.navigateToItem(dummyItem)

        // Then
        await fulfillment(of: [expectation], timeout: 0.1)
        XCTAssertTrue(mockNavigationController.pushedViewController is ItemDetailViewController)
    }
}
