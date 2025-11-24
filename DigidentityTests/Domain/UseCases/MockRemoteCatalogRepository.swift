//
//  MockCatalogRepository.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 22/11/25.
//

import Foundation

@testable import Digidentity

class MockRemoteCatalogRepository: CatalogRepository {
    var getCatalogWasCalled: Bool = false
    var result: Result<[Item], APIError>?

    func getCatalog(sinceId: String? = nil, maxId: String? = nil) async -> Result<[Item], APIError> {
        guard let result else {
            fatalError("Pendind set result")
        }
        getCatalogWasCalled = true
        return result
    }
}
