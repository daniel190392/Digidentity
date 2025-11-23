//
//  ItemDetailViewModel.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 23/11/25.
//

@MainActor
class ItemDetailViewModel {
    enum ItemDetailViewState {
        case none
        case loaded(Item)
    }

    private(set) var state: ItemDetailViewState = .none {
        didSet { onStateChange?(state) }
    }
    private(set) var onStateChange: ((ItemDetailViewState) -> Void)?
    private var item: Item

    init(item: Item) {
        self.item = item
    }

    func bind(_ listener: @escaping (ItemDetailViewState) -> Void) {
        self.onStateChange = listener
    }

    func loadItem() {
        state = .loaded(item)
    }
}
