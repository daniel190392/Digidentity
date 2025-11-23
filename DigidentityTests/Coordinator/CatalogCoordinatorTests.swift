//
//  CatalogCoordinatorTests.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 23/11/25.
//

import UIKit
import XCTest

@testable import Digidentity

@MainActor
final class CatalogCoordinatorTests: XCTestCase {

    var sut: CatalogCoordinator!
    var mockNavigationController: MockNavigationController!

    override func setUp() {
        super.setUp()
        mockNavigationController = MockNavigationController()
        sut = CatalogCoordinator(navigationController: mockNavigationController)
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
