//
//  ItemDetailBuilder.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 23/11/25.
//

import UIKit

final class ItemDetailBuilder {
    @MainActor
    func build(item: Item) -> ItemDetailViewController {
        let viewModel = ItemDetailViewModel(item: item)
        return ItemDetailViewController(viewModel: viewModel)
    }
}
