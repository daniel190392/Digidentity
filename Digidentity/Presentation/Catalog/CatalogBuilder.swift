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

    func withRepository(_ repository: CatalogRepository) -> Self {
        self.repository = repository
        return self
    }

    func withUseCase(_ useCase: GetCatalogUseCase) -> Self {
        self.useCase = useCase
        return self
    }

    @MainActor
    func build() -> CatalogViewController {
        let viewModel = CatalogViewModel(getCatalogUseCase: useCase)
        return CatalogViewController(viewModel: viewModel)
    }
}
