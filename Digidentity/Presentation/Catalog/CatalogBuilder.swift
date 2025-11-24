//
//  CatalogBuilder.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 22/11/25.
//

import SwiftData
import UIKit

final class CatalogBuilder {
    private let modelContainer: ModelContainer
    private var remoteRepository: CatalogRepository
    private var localRepository: CatalogRepository & LocalPersisting
    private lazy var useCase: GetCatalogUseCase = DefaultGetCatalogUseCase(remoteRepository: remoteRepository,
                                                                           localRepository: localRepository)
    private var delegate: CatalogViewModelDelegate?

    init(modelContainer: ModelContainer) async {
        self.modelContainer = modelContainer
        self.remoteRepository = RemoteCatalogRepository()
        self.localRepository = LocalCatalogRepository(modelContainer: modelContainer)
    }

    func withRemoteRepository(_ remoteRepository: CatalogRepository) -> Self {
        self.remoteRepository = remoteRepository
        return self
    }

    func withLocalRepository(_ localRepository: CatalogRepository & LocalPersisting) -> Self {
        self.localRepository = localRepository
        return self
    }

    func withUseCase(_ useCase: GetCatalogUseCase) -> Self {
        self.useCase = useCase
        return self
    }

    func withDelegate(_ delegate: CatalogViewModelDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    @MainActor
    func build() -> CatalogViewController {
        let viewModel = CatalogViewModel(getCatalogUseCase: useCase)
        viewModel.delegate = delegate
        return CatalogViewController(viewModel: viewModel)
    }
}
