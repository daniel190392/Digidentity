//
//  MockGetCatalogUseCase.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 22/11/25.
//

import Foundation

@testable import Digidentity

final class MockGetCatalogUseCase: GetCatalogUseCase {
    var executeWasCalled: Bool = false
    var executeCountCalled = 0
    var sinceId: String?
    var maxId: String?
    var resultToReturn: Result<[Item], APIError> = .success([])

    func execute(sinceId: String? = nil, maxId: String? = nil) async -> Result<[Item], APIError> {
        self.sinceId = sinceId
        self.maxId = maxId
        executeCountCalled += 1
        executeWasCalled = true
        return resultToReturn
    }
}
