//
//  ItemDetailBuilderTests.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 23/11/25.
//

import XCTest

@testable import Digidentity

@MainActor
final class ItemDetailBuilderTests: XCTestCase {
    var dummyItem = Item(id: "1", text: "2", confidence: 3, image: "image")

    func testBuildWithDefaults() {
        // Given
        let builder = ItemDetailBuilder()

        // When
        let viewController = builder.build(item: dummyItem)

        // Then
        XCTAssertNotNil(viewController)
    }
}
