//
//  LocalCatalogRepository.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 24/11/25.
//

import Foundation
import SwiftData

protocol LocalPersisting: Actor {
    func save(items: [Item]) throws
}

actor LocalCatalogRepository: CatalogRepository, LocalPersisting {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        self.modelContext = ModelContext(modelContainer)
    }

    func getCatalog(sinceId: String?, maxId: String?) async -> Result<[Item], APIError> {
        do {
            var predicate: Predicate<ItemEntity>?

            if let maxId {
                predicate = #Predicate<ItemEntity> { item in
                    item.id < maxId
                }
            }

            var descriptor = FetchDescriptor<ItemEntity>(
                predicate: predicate,
                sortBy: [SortDescriptor(\ItemEntity.id, order: .reverse)]
            )

            descriptor.fetchLimit = 10

            let results = try modelContext.fetch(descriptor)
            return .success(results.map { $0.toDomain() })
        } catch {
            return .failure(.databaseError(underlying: error))
        }
    }

    func save(items: [Item]) throws {
        let descriptor = FetchDescriptor<ItemEntity>()
        let existingItems = (try? modelContext.fetch(descriptor)) ?? []

        for item in items {
            if let existing = existingItems.first(where: { $0.id == item.id }) {
                existing.text = item.text
                existing.confidence = item.confidence
                existing.image = item.image
            } else {
                modelContext.insert(ItemEntity(
                    id: item.id,
                    text: item.text,
                    confidence: item.confidence,
                    image: item.image
                ))
            }
        }

        try modelContext.save()
    }
}
