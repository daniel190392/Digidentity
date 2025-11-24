//
//  ItemEntity.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 24/11/25.
//

import SwiftData

@Model
final class ItemEntity: Identifiable {
    @Attribute(.unique) var id: String
    @Attribute var text: String
    @Attribute var confidence: Double
    @Attribute var image: String

    init(id: String, text: String, confidence: Double, image: String) {
        self.id = id
        self.text = text
        self.confidence = confidence
        self.image = image
    }
}

extension ItemEntity {
    func toDomain() -> Item {
        Item(id: id, text: text, confidence: confidence, image: image)
    }
}
