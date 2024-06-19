//
//  AddLocationView.swift
//  LocationsList
//
//  Created by Igor Chertenkov on 19/06/2024.
//

import SwiftUI

extension AddLocation {
    struct UI: View {
        @ObservedObject var viewModel: ViewModel
        
        var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                Text("Enter Location Details")
                    .font(.headline)
                    .padding(.bottom, 10)
                
                TextField("Location Name", text: $viewModel.locationName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                TextField("Latitude", text: $viewModel.latitude)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                TextField("Longitude", text: $viewModel.longitude)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                HStack {
                    Spacer()
                    Button("Done", action: viewModel.done)
                        .buttonStyle(BorderedProminentButtonStyle())
                        .disabled(!viewModel.isFormValid)
                    Spacer()
                    Button("Cancel", action: viewModel.cancel)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    AddLocation.UI(viewModel: AddLocation.ViewModel())
}
