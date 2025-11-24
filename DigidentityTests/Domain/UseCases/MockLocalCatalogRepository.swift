//
//  MockLocalCatalogRepository.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 24/11/25.
//

import Foundation

@testable import Digidentity

actor MockLocalCatalogRepository: CatalogRepository & LocalPersisting {
    var getCatalogWasCalled: Bool = false
    var saveItemsWasCalled: Bool = false
    private(set) var resultCatalog: Result<[Item], APIError>?

    func getCatalog(sinceId: String? = nil, maxId: String? = nil) async -> Result<[Item], APIError> {
        guard let resultCatalog else {
            fatalError("Pendind set result")
        }
        getCatalogWasCalled = true
        return resultCatalog
    }

    func save(items: [Item]) throws {
        saveItemsWasCalled = true
        resultCatalog = .success(items)
    }
}
