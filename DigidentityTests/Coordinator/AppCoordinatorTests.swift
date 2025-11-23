//
//  AppCoordinatorTests.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 23/11/25.
//

import UIKit
import XCTest

@testable import Digidentity

@MainActor
final class AppCoordinatorTests: XCTestCase {
    var sut: AppCoordinator!
    var mockNavigationController: MockNavigationController!

    override func setUp() {
        super.setUp()
        mockNavigationController = MockNavigationController()
        sut = AppCoordinator(navigationController: mockNavigationController)
    }

    func test_start_initializesAndStartsCatalogCoordinator() {
        // When
        sut.start()

        // Then
        XCTAssertEqual(sut.childCoordinators.count, 1)
        guard sut.childCoordinators.first is CatalogCoordinator else {
            return XCTFail("CatalogCoordinator not registered")
        }
    }
}
