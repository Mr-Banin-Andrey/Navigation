//
//  FeedViewModelTests.swift
//  NavigationTests
//
//  Created by Андрей Банин on 26.9.23..
//

import XCTest
@testable import Navigation

final class FeedViewModelTests: XCTestCase {
    

    func testStateCheckedSuccess() {
        let viewModel = FeedViewModel()
                
        let feedViewModelProtocolMock = FeedViewModelProtocolMock()
        
        let successValue = Value(text: " \("feedModel.isCheckResult.true".localized) ", color: "green")
        
        let stateChecked: FeedViewModel.State = .checked(successValue)
        
        viewModel.delegate = feedViewModelProtocolMock
        
        
        feedViewModelProtocolMock.fakeResult = .success(successValue)
        viewModel.updateState(viewInput: .guessWord(word: "word"))
        
        
        let stateTotal = viewModel.state
        

        XCTAssertEqual(viewModel.state, .checked(successValue))
    }

}

class FeedViewModelProtocolMock: FeedModelProtocol {
    
    var fakeResult: Result<Value, CheckError>!
    func isCheck(word: String, completion: @escaping ((Result<Value, CheckError>) -> Void)) {
        completion(fakeResult)
        
    }
    
}
