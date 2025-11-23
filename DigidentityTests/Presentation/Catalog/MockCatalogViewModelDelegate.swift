//
//  MockCatalogViewModelDelegate.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 23/11/25.
//

import Foundation

@testable import Digidentity

final class MockCatalogViewModelDelegate: CatalogViewModelDelegate {
    var navigateToItemWasCalled = false
    var item: Item?

    func navigateToItem(_ item: Item) {
        navigateToItemWasCalled = true
        self.item = item
    }
}
