//
//  ItemDetailViewModelTests.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 23/11/25.
//

import XCTest

@testable import Digidentity

@MainActor
final class ItemDetailViewModelTests: XCTestCase {

    var sut: ItemDetailViewModel!
    let dummyItem = Item(id: "1", text: "2", confidence: 3, image: "image")

    override func setUp() {
        super.setUp()
        sut = ItemDetailViewModel(item: dummyItem)
    }

    func testInitialStateIsNone() {
        // Then
        if case .none = sut.state {
            XCTAssertTrue(true)
        } else {
            XCTFail("Not expected state")
        }
    }

    func testLoadItemUpdatesStateToLoaded() {
        // When
        sut.loadItem()

        // Then
        if case .loaded(let item) = sut.state {
            XCTAssertEqual(item.id, dummyItem.id)
        } else {
            XCTFail("Not expected state")
        }
    }

    func testBindCallsListenerOnStateChange() {
        // Given
        let expectation = XCTestExpectation(description: "Binding")
        var receivedState: ItemDetailViewModel.ItemDetailViewState?

        sut.bind { state in
            receivedState = state
            expectation.fulfill()
        }

        // When
        sut.loadItem()

        // Then
        wait(for: [expectation], timeout: 1.0)
        if case .loaded(let item) = receivedState {
            XCTAssertEqual(item.id, dummyItem.id)
        } else {
            XCTFail("Not expected state")
        }
    }
}
