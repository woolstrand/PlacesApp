//
//  ExternalActionService.swift
//  LocationsList
//
//  Created by Igor Chertenkov on 18/06/2024.
//

import Foundation

protocol ExternalActionService {
    func executeAction(for location: Location)
}
