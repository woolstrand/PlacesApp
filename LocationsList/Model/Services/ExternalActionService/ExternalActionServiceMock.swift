//
//  ExternalActionServiceMock.swift
//  LocationsList
//
//  Created by Igor Chertenkov on 18/06/2024.
//

import Foundation

class ExternalActionServiceMock: ExternalActionService {
    var objectForAction: Location?
    func executeAction(for location: Location) {
        self.objectForAction = location
    }
}
