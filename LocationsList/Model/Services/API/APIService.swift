//
//  APIService.swift
//  LocationsList
//
//  Created by Igor Chertenkov on 18/06/2024.
//

import Foundation
// In a real app we can have a lot of errors here and different ways of handling/retrial
enum APIError: Error {
    case internalInconsistency
}

protocol APIService {
    func loadLocations() async throws -> [Location]
}
