//
//  AddLocationViewModel.swift
//  LocationsList
//
//  Created by Igor Chertenkov on 19/06/2024.
//

import Foundation
import Combine

extension AddLocation {
    class ViewModel: ObservableObject {
        @Published var locationName: String = ""
        @Published var latitude: String = ""
        @Published var longitude: String = ""
        
        @Published var isFormValid: Bool = false
        private var subs = Set<AnyCancellable>()
        
        private let locationValueSubject = PassthroughSubject<Location, Never>()
        var locationValuePublisher: AnyPublisher<Location, Never> {
            locationValueSubject.eraseToAnyPublisher()
        }
        
        init() {
            Publishers.CombineLatest($latitude, $longitude)
                        .map { latitude, longitude in
                            Double(latitude) != nil && Double(longitude) != nil
                        }
                        .assign(to: \.isFormValid, on: self)
                        .store(in: &subs)
        }
        
        func done() {
            if let numericLatitude = Double(latitude),
               let numericLongitude = Double(longitude) {
                let location = Location(
                    name: locationName,
                    latitude: numericLatitude,
                    longitude: numericLongitude
                )

                locationValueSubject.send(location)
                locationValueSubject.send(completion: .finished)
            }
        }
        
        func cancel() {
            locationValueSubject.send(completion: .finished)
        }
    }
}
