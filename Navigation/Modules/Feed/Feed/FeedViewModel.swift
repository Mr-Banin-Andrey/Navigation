

import Foundation

protocol FeedViewModelProtocol {
    var onStateDidChange: ((FeedViewModel.State) -> Void)? { get set }
    func updateState(viewInput: FeedViewModel.ViewInput)
}

class FeedViewModel: FeedViewModelProtocol {
    
    enum State {
        case initial
        case checking(check: FeedModel.Value)
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
    
    func updateState(viewInput: ViewInput) {
        switch viewInput {
        case .showPostVC:
            coordinator?.showPostVC()
        case .showInfoVC:
            coordinator?.showInfoVC()
        
        case let .guessWord(word):
           let isCheck = FeedModel().isCheck(word: word) { result in
                switch result {
                case .success:
                    print("success")
                case .failure:
                    print("failure")
                }
            }
            state = .checking(check: isCheck)
        }
    }
}
