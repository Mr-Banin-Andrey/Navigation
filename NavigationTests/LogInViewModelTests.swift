//
//  LogInViewModelTests.swift
//  NavigationTests
//
//  Created by Андрей Банин on 2.10.23..
//

import XCTest
@testable import Navigation

final class LogInViewModelTests: XCTestCase {

    var viewModel: LogInViewModel!
    var checkerServiceProtocolMock: CheckerServiceProtocolMock!
    
    override func setUp() {
        viewModel = LogInViewModel()
        checkerServiceProtocolMock = CheckerServiceProtocolMock()
    }

    override func tearDown() {
        viewModel = nil
        checkerServiceProtocolMock = nil
    }
    
    func testStateIncorrectPassword() {
           
        viewModel.checkerService = checkerServiceProtocolMock
        checkerServiceProtocolMock.fakeResult = .failure(.unknownError(reason: "The password is invalid or the user does not have a password."))
        viewModel.updateState(viewInput: .singIn(user: LogInUser(login: "", password: "")))
        
        XCTAssertEqual(viewModel.state, .incorrectPassword)
    }
    
    func testStateUserDoesNotExist() {

        viewModel.checkerService = checkerServiceProtocolMock
        checkerServiceProtocolMock.fakeResult = .failure(.unknownError(reason: "There is no user record corresponding to this identifier. The user may have been deleted."))
        viewModel.updateState(viewInput: .singIn(user: LogInUser(login: "", password: "")))
        
        XCTAssertEqual(viewModel.state, .userDoesNotExist)
    }
    
    func testUserIsAuthorized() {
      
        viewModel.checkerService = checkerServiceProtocolMock
        checkerServiceProtocolMock.fakeResult = .success(UserModel(from: ""))
        viewModel.updateState(viewInput: .willNewUserRegistration(user: LogInUser(login: "", password: "")))
        
        XCTAssertEqual(viewModel.state, .userIsAuthorized)
    }
    
}

class CheckerServiceProtocolMock: CheckerServiceProtocol {
    
    var fakeResult: Result<UserModel, CheckerError>!
    func singUp(withEmail email: String, password: String, completion: @escaping (Result<Navigation.UserModel, Navigation.CheckerError>) -> Void) {
        completion(fakeResult)
    }
    
    func checkCredentials(withEmail email: String, password: String, completion: @escaping (Result<Navigation.UserModel, Navigation.CheckerError>) -> Void) {
        completion(fakeResult)
    }
    
    func singOut() throws {
        print("")
    }
}
