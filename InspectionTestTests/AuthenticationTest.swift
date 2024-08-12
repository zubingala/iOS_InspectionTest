//
//  AuthenticationTest.swift
//  InspectionTestTests
//
//  Created by Zubin Gala on 12/08/24.
//

import XCTest
@testable import InspectionTest


final class AuthenticationTests: XCTestCase {
    private let apiServiceManager = NetworkManager()
       private let testEmail = "test@test.com"
       private let testPassword = "test@123"
       private let timeout: TimeInterval = 5

    func testRegister() {
        //Arrange
        let request = AuthenticationRequest(email: testEmail, password: testPassword )
        guard let urlRequest = AuthenticationType.register.createRequest(with: request) else { return }
        
        let expectation = self.expectation(description: "User registered successfully.")
        
        //Act
        apiServiceManager.authenticateUser(urlRequest: urlRequest) { result in
            //Assert
            switch result {
            case .success:
                XCTAssertTrue(true)
            case .failure(let error):
                XCTFail("expected to be success but got a failure with error \(error.localizedDescription)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout, handler: nil)
    }

    func testLogin() {
        //Arrange
        let request = AuthenticationRequest(email: testEmail, password: testPassword )
        guard let urlRequest = AuthenticationType.login.createRequest(with: request) else { return }
        let expectation = self.expectation(description: "User login successfully")
        
        //Act
        apiServiceManager.authenticateUser(urlRequest: urlRequest) { result in
            //Assert
            switch result {
            case .success:
                XCTAssertTrue(true)
            case .failure(let error):
                XCTFail("expected to be success but got a failure with error \(error.localizedDescription)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testRegisterWithExistingUser() {
        //Arrange
        let request = AuthenticationRequest(email: testEmail, password: testPassword )
        guard let urlRequest = AuthenticationType.register.createRequest(with: request) else { return }
        let expectation = self.expectation(description: "User already exists error")
        
        //Act
        apiServiceManager.authenticateUser(urlRequest: urlRequest) { result in
            //Assert
            switch result {
            case .success:
                XCTFail("expected to be failure but got a success with error")
            case .failure(let error as NSError):
                XCTAssertTrue(true)
                XCTAssertEqual(401, error.code)
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testLoginWithNonExististingUser() {
        //Arrange
        let request = AuthenticationRequest(email: testEmail, password: testPassword )
        guard let urlRequest = AuthenticationType.login.createRequest(with: request) else { return }
        let expectation = self.expectation(description: "User doesn't exists error")
        
        //Act
        apiServiceManager.authenticateUser(urlRequest: urlRequest) { result in
            //Assert
            switch result {
            case .success:
                XCTFail("expected to be failure but got a success with error")
            case .failure(let error as NSError):
                XCTAssertTrue(true)
                XCTAssertEqual(401, error.code)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout, handler: nil)
    }
}
