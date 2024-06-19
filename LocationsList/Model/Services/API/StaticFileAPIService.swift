//
//  StaticFileAPIService.swift
//  LocationsList
//
//  Created by Igor Chertenkov on 18/06/2024.
//

import Foundation

class StaticFileAPIService: APIService {
    private enum Constants {
        static let remoteFileLink = "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json"
    }

    private struct LocationsContainer: Decodable {
        let locations: [Location]
    }
    
    // In a real app with authentication session is usually injected from the outside
    private let session = URLSession.shared
    
    func loadLocations() async throws -> [Location] {
        guard let url = URL(string: Constants.remoteFileLink) else {
            throw APIError.internalInconsistency
        }
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        
        return try await withCheckedThrowingContinuation { continuation in
            session.dataTask(with: request) { data, response, error in
                do {
                    guard let data else {
                        if let error {
                            continuation.resume(throwing: error)
                        } else {
                            continuation.resume(throwing: APIError.internalInconsistency)
                        }
                        
                        return
                    }
                    
                    let decoder = JSONDecoder()
                    let container = try decoder.decode(LocationsContainer.self, from: data)
                    continuation.resume(returning: container.locations)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
            .resume()
        }
    }
}
