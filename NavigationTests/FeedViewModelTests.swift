

import XCTest
@testable import Navigation

final class FeedViewModelTests: XCTestCase {
    
    var viewModel: FeedViewModel!
    var feedViewModelProtocolMock: FeedModelProtocolMock!
    
    override func setUp() {
        viewModel = FeedViewModel()
        feedViewModelProtocolMock = FeedModelProtocolMock()
    }

    override func tearDown() {
        viewModel = nil
        feedViewModelProtocolMock = nil
    }

    func testStateCheckedSuccess() {
        let value = Value(text: " \("feedModel.isCheckResult.true".localized) ", color: "green")
                
        viewModel.delegate = feedViewModelProtocolMock
        feedViewModelProtocolMock.fakeResult = .success(value)
        viewModel.updateState(viewInput: .guessWord(word: ""))

        XCTAssertEqual(viewModel.state, .checked(value))
    }
    
    func testStateErrorFailure() {
        let value = Value(text: " \("feedModel.isCheckResult.false".localized) ", color: "red")
        
        viewModel.delegate = feedViewModelProtocolMock
        feedViewModelProtocolMock.fakeResult = .failure(.wrong(value: value))
        viewModel.updateState(viewInput: .guessWord(word: ""))
                
        XCTAssertEqual(viewModel.state, .error(.wrong(value: value)))
    }
    
    func testStateErrorFailureEmptyField() {
        let value = Value(text: " \("feedModel.isCheckResult.false".localized) ", color: "red")
        
        viewModel.delegate = feedViewModelProtocolMock
        feedViewModelProtocolMock.fakeResult = .failure(.emptyValue(value: value))
        viewModel.updateState(viewInput: .guessWord(word: ""))
                
        XCTAssertEqual(viewModel.state, .error(.emptyValue(value: value)))
    }
}

class FeedModelProtocolMock: FeedModelProtocol {
    
    var fakeResult: Result<Value, CheckError>!
    func isCheck(word: String, completion: @escaping ((Result<Value, CheckError>) -> Void)) {
        completion(fakeResult)
    }
    
}
