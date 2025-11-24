//
//  ItemEntityTests.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 24/11/25.
//

import SwiftData
import XCTest

@testable import Digidentity

final class ItemEntityTests: XCTestCase {
    func testItemEntityToEntity() throws {
        // Given
        let entity = ItemEntity(
            id: "ABC",
            text: "Testing",
            confidence: 0.55,
            image: "image"
        )

        // When
        let domain = entity.toDomain()

        // Then
        XCTAssertEqual(domain.id, "ABC")
        XCTAssertEqual(domain.text, "Testing")
        XCTAssertEqual(domain.confidence, 0.55)
        XCTAssertEqual(domain.image, "image")
    }
}
