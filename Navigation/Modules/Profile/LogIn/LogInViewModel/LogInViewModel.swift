
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
        case userIsNotAuthorized
//        case newUserRegistration
//        case userIsLoggedIn
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
            print("singIn")
            checkerService.checkCredentials(
                 withEmail: user.login,
                 password: user.password,
                 vc: LogInViewController(logInViewModelProtocol: self)
            ) { result in
                switch result {
                case .success:
                    print("логин и пароль верные -> открытие профиля")
                    self.createUserRealm(user: user)
                    self.coordinator?.showProfileVC()
                case .failure(let error):
                    print("ошибка в логине или пароле", error)
                }
            }
//            state = .userIsLoggedIn
            
        case .showWindowRegistration:
            print("createUser")
            self.coordinator?.showRegistration()

        case let .willNewUserRegistration(user):
            print("newUserRegistration")
            checkerService.singUp(
                 withEmail: user.login,
                 password: user.password,
                 vc: LogInViewController(logInViewModelProtocol: self)
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
            print("didNewUserRegistration")
            self.coordinator?.showProfileVC()
        }
    }
}
