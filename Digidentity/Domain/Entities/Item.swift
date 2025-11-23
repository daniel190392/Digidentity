//
//  Item.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 22/11/25.
//

struct Item {
    let id: String
    let text: String
    let confidence: Double
    let image: String
}

extension Item {
    func toItemCellViewModel() -> ItemCellViewModel {
        ItemCellViewModel(
            titleText: text,
            idText: id,
            confidenceValue: confidence,
            image: image
        )
    }
}
