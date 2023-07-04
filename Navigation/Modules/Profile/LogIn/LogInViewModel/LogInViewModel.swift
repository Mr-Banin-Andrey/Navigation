

import Foundation

@available(iOS 15.0, *)
protocol LogInViewModelProtocol {
    var onStateDidChange: ((LogInViewModel.State) -> Void)? { get set }
    func updateState(viewInput: LogInViewModel.ViewInput)
}

@available(iOS 15.0, *)
class LogInViewModel: LogInViewModelProtocol {
    
    enum State {
        case waitingForEntry
        case checkedUser
        case createNewUser
        case error(Error)
    }
    
    enum ViewInput {
        case singIn
        case createUser
    }
    
    var coordinator: ProfileCoordinator?
    
    var onStateDidChange: ((State) -> Void)?
    
    private (set) var state: State = .waitingForEntry {
        didSet {
            onStateDidChange?(state)
        }
    }
    
    func updateState(viewInput: ViewInput) {
        switch viewInput {
        case .singIn:
            print("singIn")
            self.coordinator?.showProfileVC()
        case .createUser:
            print("createUser")
        }
    }
}
