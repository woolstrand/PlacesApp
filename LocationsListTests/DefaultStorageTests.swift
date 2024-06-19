//
//  DefaultStorageTests.swift
//  DefaultStorageTests
//
//  Created by Igor Chertenkov on 19/06/2024.
//

import XCTest
@testable import LocationsList

final class DefaultStorageTests: XCTestCase {

    var storage: DefaultStorageService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        storage = DefaultStorageService()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testDefaultStorageInitiallyEmpty() throws {
        XCTAssertEqual(storage.allLocations(), [], "Store must be empty by default")
    }

    func testDefaultStorageAddition() throws {
        try storage.add(location: Location(name: "A", latitude: 1, longitude: 1))
        XCTAssertEqual(storage.allLocations().first, Location(name: "A", latitude: 1, longitude: 1), "Store must contain one element after addition of one element")
    }

    func testDefaultStorageAdditionDuplicates() throws {
        try storage.add(location: Location(name: "A", latitude: 1, longitude: 1))
        try storage.add(location: Location(name: "A", latitude: 1, longitude: 1))
        XCTAssertEqual(storage.allLocations().count, 1, "Store must filter out duplicates")
    }

    func testDefaultStorageRemoval() throws {
        try storage.add(location: Location(name: "A", latitude: 1, longitude: 1))
        try storage.add(location: Location(name: "B", latitude: 2, longitude: 2))
        try storage.remove(location: Location(name: "A", latitude: 1, longitude: 1))

        XCTAssertEqual(storage.allLocations().first, Location(name: "B", latitude: 2, longitude: 2), "Store must remove provided location")
    }

    func testDefaultStorageIgnoreMissingElementsRemoval() throws {
        try storage.add(location: Location(name: "B", latitude: 2, longitude: 2))
        try self.storage.remove(location: Location(name: "A", latitude: 1, longitude: 1))

        XCTAssertEqual(storage.allLocations().first, Location(name: "B", latitude: 2, longitude: 2), "Store must ignore removal command if provided location not found")
    }
}
