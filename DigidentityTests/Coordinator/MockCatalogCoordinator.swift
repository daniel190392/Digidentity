//
//  MockCatalogCoordinator.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 23/11/25.
//

import UIKit

@testable import Digidentity

final class MockCatalogCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var startWasCalled = false

    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        startWasCalled = true
    }
}
