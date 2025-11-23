//
//  CatalogCoordinator.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 23/11/25.
//

import UIKit

class CatalogCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        Task { @MainActor in
            let catalogViewController = CatalogBuilder()
                .withDelegate(self)
                .build()
            navigationController.pushViewController(catalogViewController, animated: false)
        }
    }
}

extension CatalogCoordinator: CatalogViewModelDelegate {
    func navigateToItem(_ item: Item) {
        Task { @MainActor in
            let itemDetailViewController = ItemDetailBuilder().build(item: item)
            navigationController.pushViewController(itemDetailViewController, animated: false)
        }
    }
}
