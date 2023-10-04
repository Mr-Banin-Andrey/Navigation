//
//  LogInViewModelTests.swift
//  NavigationTests
//
//  Created by Андрей Банин on 2.10.23..
//

import XCTest
@testable import Navigation

final class LogInViewModelTests: XCTestCase {

//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }

//case userIsAuthorized
//case incorrectPassword
//case userDoesNotExist
    
    func testStateIncorrectPassword() {
        
        let viewModel = LogInViewModel()
        let checkerServiceProtocolMock = CheckerServiceProtocolMock()
        
        viewModel.checkerService = checkerServiceProtocolMock
        checkerServiceProtocolMock.fakeResult = .failure(.unknownError(reason: "The password is invalid or the user does not have a password."))
        viewModel.updateState(viewInput: .singIn(user: LogInUser(login: "", password: "")))
        
        XCTAssertEqual(viewModel.state, .incorrectPassword) //incorrectPassword
    }
    
    func testStateUserDoesNotExist() {
        let viewModel = LogInViewModel()
        let checkerServiceProtocolMock = CheckerServiceProtocolMock()
        
        viewModel.checkerService = checkerServiceProtocolMock
        checkerServiceProtocolMock.fakeResult = .failure(.unknownError(reason: "There is no user record corresponding to this identifier. The user may have been deleted."))
        viewModel.updateState(viewInput: .singIn(user: LogInUser(login: "", password: "")))
        XCTAssertEqual(viewModel.state, .userDoesNotExist) //userDoesNotExist
    }
    
    func testUserIsAuthorized() {
        let viewModel = LogInViewModel()
        let checkerServiceProtocolMock = CheckerServiceProtocolMock()
        
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
