//
//  GetCatalogUseCase.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 22/11/25.
//

protocol GetCatalogUseCase {
    func execute(sinceId: String?, maxId: String?) async -> Result<[Item], APIError>
}

class DefaultGetCatalogUseCase: GetCatalogUseCase {
    private let repository: CatalogRepository

    init(repository: CatalogRepository) {
        self.repository = repository
    }

    func execute(sinceId: String? = nil, maxId: String? = nil) async -> Result<[Item], APIError> {
        return await repository.getCatalog(sinceId: sinceId, maxId: maxId)
    }
}
