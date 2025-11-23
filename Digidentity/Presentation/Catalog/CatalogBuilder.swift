//
//  CatalogBuilder.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 22/11/25.
//

import UIKit

final class CatalogBuilder {
    private var repository: CatalogRepository = DefaultCatalogRepository()
    private lazy var useCase: GetCatalogUseCase = DefaultGetCatalogUseCase(repository: repository)
    private var delegate: CatalogViewModelDelegate?

    func withRepository(_ repository: CatalogRepository) -> Self {
        self.repository = repository
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
