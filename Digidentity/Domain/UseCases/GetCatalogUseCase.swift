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
    private let remoteRepository: CatalogRepository
    private let localRepository: CatalogRepository & LocalPersisting
    private let networkChecker: NetworkChecking

    init(remoteRepository: CatalogRepository,
         localRepository: CatalogRepository & LocalPersisting,
         networkChecker: NetworkChecking = NetworkMonitor.shared) {
        self.remoteRepository = remoteRepository
        self.localRepository = localRepository
        self.networkChecker = networkChecker
    }

    func execute(sinceId: String? = nil, maxId: String? = nil) async -> Result<[Item], APIError> {
        if networkChecker.isConnected {
            let result = await remoteRepository.getCatalog(sinceId: sinceId, maxId: maxId)
            if case .success(let items) = result {
                do {
                    try await localRepository.save(items: items)
                } catch {
                    print("Error saving items to DB: \(error)")
                }
            }
            return result
        } else {
            return await localRepository.getCatalog(sinceId: sinceId, maxId: maxId)
        }
    }
}
