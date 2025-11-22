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
    var resultToReturn: Result<[Item], APIError> = .success([])

    func execute() async -> Result<[Item], APIError> {
        executeWasCalled = true
        return resultToReturn
    }
}
