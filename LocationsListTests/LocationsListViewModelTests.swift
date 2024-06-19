//
//  LocationsListViewModelTests.swift
//  LocationsListTests
//
//  Created by Igor Chertenkov on 19/06/2024.
//

import Foundation

import XCTest
@testable import LocationsList

final class LocationsListViewModelTests: XCTestCase {

    var viewModel: LocationsList.ViewModel!
    var apiMock: APIServiceMock!
    var storageMock: StorageServiceMock!
    var externalMock: ExternalActionServiceMock!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        apiMock = APIServiceMock()
        storageMock = StorageServiceMock()
        externalMock = ExternalActionServiceMock()
        viewModel = LocationsList.ViewModel(
            deps: .init(
                apiService: apiMock,
                storageService: storageMock,
                externalActionService: externalMock
            )
        )
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testDefaultSetup() {
        viewModel.start()
        // store mock provides 4 elements
        XCTAssertEqual(viewModel.locations.count, 4)
    }

    func testInitialContent() {
        viewModel.start()
        // after start no additions are done - API is loading
        XCTAssertEqual(storageMock.didTryAdding, false)
    }

    func testLocationsAppendingAfterLoaded() {
        viewModel.start()
        let expectation = self.expectation(description: "Update was tried after delay")
                
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(self.storageMock.didTryAdding, true)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testLocationSelection() {
        let mockLocation = Location(name: "Loc1", latitude: 10, longitude: 10)
        viewModel.start()
        viewModel.didTapItem(LocationsList.ViewModel.LocationViewModel(location: mockLocation))
        XCTAssertEqual(externalMock.objectForAction, mockLocation)
    }
    
    func testLocationSelectionForMissingLocation() {
        let mockLocation = Location(name: "Loc2", latitude: 0, longitude: 0)
        viewModel.start()
        viewModel.didTapItem(LocationsList.ViewModel.LocationViewModel(location: mockLocation))
        XCTAssertNil(externalMock.objectForAction)
    }
    
    func testAddition() {
        viewModel.start()
        viewModel.didTapAdd()
        XCTAssertTrue(viewModel.presentedAddItem)
    }

}
