//
//  CatalogViewModel.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 22/11/25.
//

import Combine
import Foundation

@MainActor
class CatalogViewModel: ObservableObject {
    enum CatalogViewState {
        case none
        case loading
        case loaded([Item])
        case error(String)
    }

    @Published private(set) var state: CatalogViewState = .none

    private let getCatalogUseCase: GetCatalogUseCase

    init(getCatalogUseCase: GetCatalogUseCase) {
        self.getCatalogUseCase = getCatalogUseCase
    }

    func loadCatalog() async {
        state = .loading
        let result = await getCatalogUseCase.execute()

        switch result {
        case .success(let items):
            state = .loaded(items)
        case .failure(let error):
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
}
