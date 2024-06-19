//
//  WikipediaExternalActionService.swift
//  LocationsList
//
//  Created by Igor Chertenkov on 18/06/2024.
//

import Foundation
import UIKit

class WikipediaExternalActionService: ExternalActionService {
    private enum Constants {
        static let linkTemplate = "wikipedia://places?WMFLocation={0},{1}"
    }
    
    func executeAction(for location: Location) {
        let wikipediaLink = Constants.linkTemplate
            .replacingOccurrences(of: "{0}", with: "\(location.latitude)")
            .replacingOccurrences(of: "{1}", with: "\(location.longitude)")
        
        if let url = URL(string: wikipediaLink) {
            UIApplication.shared.open(url)
        }
    }
}
