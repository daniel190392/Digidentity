//
//  CatalogCoordinator.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 23/11/25.
//

import SwiftData
import UIKit

class CatalogCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    private let modelContainer: ModelContainer

    init(navigationController: UINavigationController, modelContainer: ModelContainer) {
        self.navigationController = navigationController
        self.modelContainer = modelContainer
    }

    func start() {
        Task {
            let builder = await CatalogBuilder(modelContainer: modelContainer)
            await MainActor.run {
                let catalogViewController = builder
                    .withDelegate(self)
                    .build()
                navigationController.pushViewController(catalogViewController, animated: false)
            }
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
