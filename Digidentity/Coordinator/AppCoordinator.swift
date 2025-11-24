//
//  AppCoordinator.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 23/11/25.
//

import SwiftData
import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}

class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    private let modelContainer: ModelContainer

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        do {
            self.modelContainer = try ModelContainer(for: ItemEntity.self)
        } catch {
            fatalError("Cant' initialize ModelContainer: \(error)")
        }
    }

    func start() {
        let catalogCoordinator = CatalogCoordinator(navigationController: navigationController,
                                                    modelContainer: modelContainer)
        catalogCoordinator.start()
        childCoordinators.append(catalogCoordinator)
    }
}
