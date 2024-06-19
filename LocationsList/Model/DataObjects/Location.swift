//
//  Location.swift
//  LocationsList
//
//  Created by Igor Chertenkov on 18/06/2024.
//

import Foundation

struct Location: Codable {
    var name: String?
    var latitude: Double
    var longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "long"
    }
}

extension Location: Equatable {
}
