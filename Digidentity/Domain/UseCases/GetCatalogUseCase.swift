//
//  GetCatalogUseCase.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 22/11/25.
//

protocol GetCatalogUseCase {
    func execute() async -> Result<[Item], APIError>
}

class DefaultGetCatalogUseCase: GetCatalogUseCase {
    private let repository: CatalogRepository

    init(repository: CatalogRepository) {
        self.repository = repository
    }

    func execute() async -> Result<[Item], APIError> {
        return await repository.getCatalog()
    }
}
