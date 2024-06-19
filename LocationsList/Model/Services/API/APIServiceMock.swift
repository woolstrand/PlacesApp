//
//  APIServiceMock.swift
//  LocationsList
//
//  Created by Igor Chertenkov on 18/06/2024.
//

import Foundation

class APIServiceMock: APIService {
    var error: Error?
    var result: [Location]?
    var delay: UInt64 = 500_000_000
    
    init(setDefaultLocations: Bool = true) {
        if setDefaultLocations {
            self.result = [
                Location(name: "Loc1", latitude: 54.0, longitude: 82.0),
                Location(name: "Loc2", latitude: -34.0, longitude: 44.0),
                Location(name: "Loc3", latitude: 4.0, longitude: 12.0),
                Location(name: nil, latitude: 4.0, longitude: -82.0)
            ]
        }
    }
    
    func loadLocations() async throws -> [Location] {
        try? await Task.sleep(nanoseconds: delay)
        
        if let error {
            throw error
        }
        
        if let result {
            return result
        }
        
        return []
    }
}
