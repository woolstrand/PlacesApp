//
//  DefaultStorageService.swift
//  LocationsList
//
//  Created by Igor Chertenkov on 18/06/2024.
//

import Foundation

class DefaultStorageService: StorageService {
    private var locations: [Location]
    private var accessQueue: DispatchQueue
    
    init() {
        locations = []
        
        // creating a serial queue by explicitly removing .concurrent attribute
        accessQueue = DispatchQueue(label: "storage-service-default", qos: .default, attributes: [])
    }
    
    func add(location: Location) throws {
        // No one can access this queue from the outside, so I can be pretty sure I'm not on accessQueue already.
        // This means no deadlock possible even when using .sync
        accessQueue.sync {
            if !locations.contains(location) {
                locations.append(location)
            }
        }
    }
    
    func allLocations() -> [Location] {
        var locations: [Location] = []

        accessQueue.sync {
            locations = self.locations
        }
        
        return locations
    }
    
    func remove(location: Location) throws {
        accessQueue.sync {
            locations.removeAll { existingLocation in
                existingLocation == location
            }
        }
    }
}
