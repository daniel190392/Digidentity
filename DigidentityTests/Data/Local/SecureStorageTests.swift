//
//  SecureStorageTests.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 22/11/25.
//

import XCTest

@testable import Digidentity

final class SecureStorageTests: XCTestCase {
    let testKey = "testKey"
    let testValue = "testValue"

    override func setUp() {
        super.setUp()
        SecureStorage.shared.delete(testKey)
    }

    func testSaveAndGet() {
        // When
        SecureStorage.shared.save(testValue, for: testKey)

        // Then
        let value = SecureStorage.shared.get(testKey)
        XCTAssertEqual(value, testValue)
    }

    func testUpdateValue() {
        // Given
        SecureStorage.shared.save("oldValue", for: testKey)

        // When
        SecureStorage.shared.save(testValue, for: testKey)

        // Then
        let value = SecureStorage.shared.get(testKey)
        XCTAssertEqual(value, testValue)
    }

    func testDelete() {
        // Given
        SecureStorage.shared.save(testValue, for: testKey)

        // When
        SecureStorage.shared.delete(testKey)

        // Then
        let value = SecureStorage.shared.get(testKey)
        XCTAssertNil(value)
    }

    func testGetNonExistentKey() {
        // When
        let value = SecureStorage.shared.get("nonExistentKey")

        // Then
        XCTAssertNil(value, "Debe retornar nil para una clave que no existe")
    }
}
