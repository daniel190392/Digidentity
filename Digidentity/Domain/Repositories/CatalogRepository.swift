//
//  CatalogRepository.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 22/11/25.
//

protocol CatalogRepository {
    func getCatalog(sinceId: String?, maxId: String?) async -> Result<[Item], APIError>
}
