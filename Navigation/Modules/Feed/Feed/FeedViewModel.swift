

import Foundation

protocol FeedViewModelProtocol: ViewModelProtocol {
    var onStateDidChange: ((FeedViewModel.State) -> Void)? { get set }
    func updateState(viewInput: FeedViewModel.ViewInput)
}

class FeedViewModel: FeedViewModelProtocol {

    enum State: Equatable {
        
        case initial
        case checking
        case checked(Value)
        case error(CheckError)
        
        static func == (lhs: FeedViewModel.State, rhs: FeedViewModel.State) -> Bool {
            switch (lhs, rhs) {
            case ( .checked(_), .checked(_)):
                return true
            case (.error(.emptyValue(value: _)), .error(.emptyValue(value: _))):
                return true
            case (.error(.wrong(value: _)), .error(.wrong(value: _))):
                return true
            default:
                return false
            }
        }
    }
    
    enum ViewInput {
        case showPostVC
        case showInfoVC
        case guessWord(word: String)
    }
    
    var coordinator: FeedCoordinator?
    
    var onStateDidChange: ((State) -> Void)?

    private (set) var state: State = .initial {
        didSet {
            onStateDidChange?(state)
        }
    }
    
    var delegate: FeedModelProtocol = FeedModel()
    
    func updateState(viewInput: FeedViewModel.ViewInput) {
        switch viewInput {
        case .showPostVC:
            coordinator?.showPostVC()
        case .showInfoVC:
            coordinator?.showInfoVC()
        case let .guessWord(word):
            state = .checking
            delegate.isCheck(word: word) { result in
                switch result {
                case let .success(value):
                    self.state = .checked(value)
                case let .failure(error):
                    switch error {
                    case let .emptyValue(error):
                        self.state = .error(.emptyValue(value: error))
                    case let .wrong(error):
                        self.state = .error(.wrong(value: error))
                    }
                }
            }
        }
    }
}
