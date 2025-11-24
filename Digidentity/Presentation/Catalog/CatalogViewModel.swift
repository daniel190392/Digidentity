//
//  CatalogViewModel.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 22/11/25.
//

import Foundation

protocol CatalogViewModelDelegate: AnyObject {
    func navigateToItem(_ item: Item)
}

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

    weak var delegate: CatalogViewModelDelegate?

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

    func selectItem(at index: Int) {
        delegate?.navigateToItem(items[index])
    }
}

private extension CatalogViewModel {
    func handleError(_ error: APIError) {
        switch error {
        case .badURL:
            print("The URL is invalid")
            state = .error("We cannot reach the server. Please try again later.")
        case .badServerResponse(let code):
            print("Server response: \(code)")
            state = .error("There was a problem with the server. Please try again later.")
        case .decodingError(let underlying):
            print("Decoding error: \(underlying.localizedDescription)")
            state = .error("We received unexpected data from the server. Please try again later.")
        case .networkError(let underlying):
            print("Network error: \(underlying.localizedDescription)")
            state = .error("There was a network problem. Check your connection and try again.")
        case .databaseError(underlying: let underlying):
            print("Database error: \(underlying.localizedDescription)")
            state = .error("We could not access local data. Please try again later.")
        }
    }
}
