//
//  LocationsListView.swift
//  LocationsList
//
//  Created by Igor Chertenkov on 18/06/2024.
//

import SwiftUI

extension LocationsList {
    struct UI: View {
        @ObservedObject var viewModel: ViewModel
        
        init(viewModel: ViewModel) {
            self.viewModel = viewModel
        }
        
        var body: some View {
            NavigationStack {
                ScrollView {
                    ForEach(viewModel.locations) { location in
                        VStack(alignment: .leading, spacing: 8) {
                            if let name = location.name {
                                Text(name)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                            } else {
                                Text("(no title)")
                                    .foregroundColor(.gray)
                            }
                            
                            HStack(spacing: 4) {
                                Text("Lat: \(location.latitude)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("Lon: \(location.longitude)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemBackground).opacity(0.7))
                        .cornerRadius(10)
                        .shadow(radius: 2)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 4)
                        .onTapGesture {
                            viewModel.didTapItem(location)
                        }
                    }
                    Button("Add new item", action: viewModel.didTapAdd)
                        .buttonStyle(BorderedProminentButtonStyle())
                        .padding(.vertical, 16)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.secondarySystemBackground))
                .refreshable {
                    viewModel.refreshLocations()
                }
                .navigationDestination(
                    isPresented: $viewModel.presentedAddItem,
                    destination: {
                        AddLocation.UI(viewModel: viewModel.addLocationViewModel())
                    }
                )
                .onAppear(perform: {
                    viewModel.start()
                })
            }
        }
    }
}

#Preview {
    LocationsList.UI(
        viewModel: LocationsList.ViewModel(
            deps: .init(
                apiService: APIServiceMock(setDefaultLocations: true),
                storageService: StorageServiceMock(),
                externalActionService: ExternalActionServiceMock()
            )
        )
    )
}
