//
//  StorageService.swift
//  LocationsList
//
//  Created by Igor Chertenkov on 18/06/2024.
//

import Foundation

enum StorageError: Error {
    case internalInconsistencyError
    case itemNotFound
}

protocol StorageService {
    func add(location: Location) throws
    func allLocations() -> [Location]
    func remove(location: Location) throws
}
