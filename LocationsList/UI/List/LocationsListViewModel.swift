//
//  LocationsListViewModel.swift
//  LocationsList
//
//  Created by Igor Chertenkov on 18/06/2024.
//

import Combine
import Foundation
import SwiftUI

extension LocationsList {
    class ViewModel: ObservableObject {
        struct Deps {
            let apiService: APIService
            let storageService: StorageService
            let externalActionService: ExternalActionService
        }
        
        struct LocationViewModel: Identifiable {
            let name: String?
            var latitude: Double
            var longitude: Double
            let id = UUID().uuidString
            
            init(location: Location) {
                self.name = location.name
                self.latitude = location.latitude
                self.longitude = location.longitude
            }
        }
        
        var deps: Deps
        
        @Published var locations: [LocationViewModel] = []
        @Published var presentedAddItem = false
        @Published var isBusy = false
        
        private var subs = Set<AnyCancellable>()
        
        init(deps: Deps) {
            self.deps = deps
        }
        
        func start() {            
            updateLocationsFromStore()
            refreshLocations()
        }
        
        func refreshLocations() {
            isBusy = true
            Task {
                do {
                    let newLocations = try await deps.apiService.loadLocations()
                    
                    for location in newLocations {
                        try deps.storageService.add(location: location)
                    }
                    
                    // No need for weak self because we do not capture MainActor, thus no retain cycle
                    await MainActor.run {
                        self.updateLocationsFromStore()
                        self.isBusy = false
                    }
                } catch {
                    // TODO: dialog
                }
            }
        }
        
        private func updateLocationsFromStore() {
            self.locations = deps.storageService.allLocations().map{ .init(location: $0) }
        }
        
        func didTapItem(_ selectedLocationViewModel: LocationViewModel) {
            guard let location = self.deps.storageService.allLocations().first(where: { storedLocation in
                storedLocation.name == selectedLocationViewModel.name &&
                storedLocation.latitude == selectedLocationViewModel.latitude &&
                storedLocation.longitude == selectedLocationViewModel.longitude
            }) else {
                return
            }
            
            deps.externalActionService.executeAction(for: location)
        }
        
        func didTapAdd() {
            presentedAddItem = true
        }
        
        func addLocationViewModel() -> AddLocation.ViewModel {
            let viewModel = AddLocation.ViewModel()
            viewModel.locationValuePublisher
                .sink { _ in
                    self.presentedAddItem = false
                } receiveValue: { location in
                    try? self.deps.storageService.add(location: location)
                    self.updateLocationsFromStore()
                }
                .store(in: &subs)

            return viewModel
        }
    }
}
