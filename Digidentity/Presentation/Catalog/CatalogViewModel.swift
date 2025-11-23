//
//  CatalogViewModel.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 22/11/25.
//

import Foundation

@MainActor
class CatalogViewModel {
    enum CatalogViewState {
        case none
        case loading
        case loadingMore([Item])
        case loaded([Item])
        case error(String)
    }

    private let getCatalogUseCase: GetCatalogUseCase
    private(set) var state: CatalogViewState = .none {
        didSet { onStateChange?(state) }
    }
    private(set) var onStateChange: ((CatalogViewState) -> Void)?
    private var items: [Item] = []
    private var isLoadingMore = false
    private var hasMorePages = true

    init(getCatalogUseCase: GetCatalogUseCase) {
        self.getCatalogUseCase = getCatalogUseCase
    }

    func bind(_ listener: @escaping (CatalogViewState) -> Void) {
        self.onStateChange = listener
    }

    func loadCatalog() async {
        state = .loading
        let result = await getCatalogUseCase.execute(sinceId: nil, maxId: nil)

        switch result {
        case .success(let newItems):
            items = newItems
            state = .loaded(items)
        case .failure(let error):
            handleError(error)
        }
    }

    func loadNextPage() async {
        guard let lastId = items.last?.id, !isLoadingMore, hasMorePages else { return }

        isLoadingMore = true
        defer { isLoadingMore = false }
        state = .loadingMore(items)

        let result = await getCatalogUseCase.execute(sinceId: nil, maxId: lastId)

        switch result {
        case .success(let newItems):
            hasMorePages = !newItems.isEmpty
            items.append(contentsOf: newItems)
            state = .loaded(items)
        case .failure(let error):
            handleError(error)
        }
    }
}

private extension CatalogViewModel {
    func handleError(_ error: APIError) {
        switch error {
        case .badURL:
            state = .error("La URL es inválida")
        case .badServerResponse(let code):
            state = .error("Respuesta del servidor: \(code)")
        case .decodingError(let underlying):
            state = .error("Error al decodificar: \(underlying.localizedDescription)")
        case .networkError(let underlying):
            state = .error("Error de red: \(underlying.localizedDescription)")
        }
    }
}
