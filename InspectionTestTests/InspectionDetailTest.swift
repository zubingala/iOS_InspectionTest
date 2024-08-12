//
//  InspectionDetailTest.swift
//  InspectionTestTests
//
//  Created by Zubin Gala on 12/08/24.
//

import XCTest
@testable import InspectionTest

final class InspectionDetailTest: XCTestCase {
    
    private var networkManager: NetworkManager!
    
    override func setUp() {
        super.setUp()
        networkManager = NetworkManager()
    }
    
    override func tearDown() {
        networkManager = nil
        super.tearDown()
    }
    
    func testStartInspection() {
        // Arrange
        let expectation = self.expectation(description: "Inspection Data fetched")
        
        // Act
        networkManager.getInspectionDataAndStart { result in
            // Assert
            switch result {
            case .success(let inspectionData):
                XCTAssertNotNil(inspectionData, "Inspection data should not be nil")
                
            case .failure(let error):
                XCTFail("Expected success but received failure with error: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0)
    }
}

