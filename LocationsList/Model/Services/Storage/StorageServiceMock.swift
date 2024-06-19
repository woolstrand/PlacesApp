//
//  StorageServiceMock.swift
//  LocationsList
//
//  Created by Igor Chertenkov on 18/06/2024.
//

import Foundation

class StorageServiceMock: StorageService {
    var didTryAdding = false
    func add(location: Location) throws {
        didTryAdding = true
    }
    
    func allLocations() -> [Location] {
        [
            Location(name: "Loc1", latitude: 10.0, longitude: 10.0),
            Location(name: "Loc2", latitude: -34.0, longitude: 44.0),
            Location(name: "Loc3", latitude: 4.0, longitude: 12.0),
            Location(name: nil, latitude: 4.0, longitude: -82.0)
        ]
    }
    
    func remove(location: Location) throws {
    }
}
