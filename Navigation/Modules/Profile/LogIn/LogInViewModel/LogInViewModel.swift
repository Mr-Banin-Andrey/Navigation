
import Foundation

@available(iOS 15.0, *)
protocol LogInViewModelProtocol: ViewModelProtocol {
    var onStateDidChange: ((LogInViewModel.State) -> Void)? { get set }
    func updateState(viewInput: LogInViewModel.ViewInput)
}

@available(iOS 15.0, *)
class LogInViewModel: LogInViewModelProtocol {
    
    enum State {
        case waitingForEntry
        case userIsAuthorized
        case incorrectPassword
        case userDoesNotExist
        case error(Error)
    }
    
    enum ViewInput {
        case singIn(user: LogInUser)
        case showWindowRegistration
        case willNewUserRegistration(user: LogInUser)
        case didNewUserRegistration
    }
    
    private let checkerService = CheckerService()
    private let dataBaseRealmService: RealmServiceProtocol = RealmService()

    var coordinator: ProfileCoordinator?
    
    var onStateDidChange: ((State) -> Void)?
    
    private (set) var state: State = .waitingForEntry {
        didSet {
            onStateDidChange?(state)
        }
    }
    
    private func createUserRealm(user: LogInUser) {
        let success = dataBaseRealmService.createUser(user: user)
        if success {
            print("пользователь добавлен в базу Realm")
        } else {
            print("пользователь уже есть в базе Realm")
        }
    }
    
    func updateState(viewInput: LogInViewModel.ViewInput) {
        switch viewInput {
        
        case let .singIn(user):
            checkerService.checkCredentials(
                 withEmail: user.login,
                 password: user.password
            ) { result in
                switch result {
                case .success:
                    print("логин и пароль верные -> открытие профиля")
                    self.createUserRealm(user: user)
                    self.coordinator?.showProfileVC()
                case .failure(let error):
                    switch error {
                    case let .unknownError(reason: error):
                        if error == "The password is invalid or the user does not have a password." {
                            print("ошибка пароля")
                            self.state = .incorrectPassword
                        } else if error == "There is no user record corresponding to this identifier. The user may have been deleted." {
                            print("пользователя не существует")
                            self.state = .userDoesNotExist
                        }
                    case .noUserRecord:
                        self.state = .userDoesNotExist
                    }
                }
            }
            
        case .showWindowRegistration:
            self.coordinator?.showRegistration()

        case let .willNewUserRegistration(user):
            checkerService.singUp(
                 withEmail: user.login,
                 password: user.password
            ) { result in
                switch result {
                case .success:
                    print("пользователь добавлен в firebase")
                    self.createUserRealm(user: user)
                    self.state = .userIsAuthorized
                case .failure(let error):
                    print("ошибка в firebase: ", error)
                }
            }
        case .didNewUserRegistration:
            self.coordinator?.showProfileVC()
        }
    }
}
