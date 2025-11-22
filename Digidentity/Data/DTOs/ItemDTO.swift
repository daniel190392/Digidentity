//
//  Item.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 22/11/25.
//

struct ItemDTO: Codable {
    let id: String
    let text: String
    let confidence: Double
    let image: String

    enum CodingKeys: String, CodingKey {
        case text, confidence, image
        case id = "_id"
    }
}

extension ItemDTO {
    func toEntity() -> Item {
        return Item(id: id, text: text, confidence: confidence, image: image)
    }
}
