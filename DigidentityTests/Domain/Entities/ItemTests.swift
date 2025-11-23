//
//  ItemTests.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 23/11/25.
//

import XCTest

@testable import Digidentity

final class ItemTests: XCTestCase {
    func testItemToI() {
        // Given
        let item = Item(id: "123",
                        text: "Test Item",
                        confidence: 10.0,
                        image: "URL")

        // When
        let viewModel = item.toItemCellViewModel()

        // Then
        XCTAssertEqual(viewModel.idText, item.id)
        XCTAssertEqual(viewModel.titleText, item.text)
        XCTAssertEqual(viewModel.confidenceValue, item.confidence)
        XCTAssertEqual(viewModel.image, item.image)
    }
}
