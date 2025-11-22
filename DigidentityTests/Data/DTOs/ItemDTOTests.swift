//
//  ItemDTOTests.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 22/11/25.
//

import XCTest

@testable import Digidentity

final class ItemDTOTests: XCTestCase {
    func testDTOToEntity() {
        // Given
        let dto = ItemDTO(id: "123",
                          text: "Test Item",
                          confidence: 10.0,
                          image: "URL")

        // When
        let entity = dto.toEntity()

        // Then
        XCTAssertEqual(entity.id, dto.id)
        XCTAssertEqual(entity.text, dto.text)
        XCTAssertEqual(entity.confidence, dto.confidence)
        XCTAssertEqual(entity.image, dto.image)
    }
}
