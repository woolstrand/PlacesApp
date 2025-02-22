//
//  LocationsListApp.swift
//  LocationsList
//
//  Created by Igor Chertenkov on 18/06/2024.
//

import SwiftUI

@main
struct LocationsListApp: App {
    var body: some Scene {
        WindowGroup {
            LocationsList.UI(
                viewModel: LocationsList.ViewModel(
                    deps: .init(
                        apiService: StaticFileAPIService(),
                        storageService: DefaultStorageService(),
                        externalActionService: WikipediaExternalActionService()
                    )
                )
            )
        }
    }
}
