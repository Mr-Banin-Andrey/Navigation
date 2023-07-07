

import UIKit

@available(iOS 15.0, *)
protocol LoginViewControllerDelegate {
    func isCheck(_ sender: LogInViewController, login: String, password: String) -> Bool
}

@available(iOS 15.0, *)
struct LoginInspector: LoginViewControllerDelegate {
    func isCheck(_ sender: LogInViewController, login: String, password: String) -> Bool {
        return Checker.shared.isCheck(sender, login: login, password: password)
    }
}

@available(iOS 15.0, *)
class LogInViewController: UIViewController {
    
//MARK: - 1. Properties

    var loginDelegate: LoginViewControllerDelegate?
    
    private lazy var logInView = LogInView(delegate: self)
    
    private let checkerService = CheckerService()
    
    private let dataBaseRealmService: RealmServiceProtocol = RealmService()
        
    
    var viewModel: LogInViewModelProtocol? {
        didSet {
            self.viewModel?.onStateDidChange = { [weak self] state in
                guard let self = self else { return }
                
                switch state {
                case .waitingForEntry:
                    print("waitingForEntry")
                
                case .userIsAuthorized:
                    print("userIsAuthorized")
                    showAlert()
//                    logInView.autoAuth()
                    
                case .userIsNotAuthorized:
                    print("userIsNotAuthorized")
                
                case .newUserRegistration:
                    print("newUserRegistration 🍉")
                    logInView.viewPresent(
                        hidden: true,
                        buttonTitle: "loginVC.modalPresent.logInButton.title".localized,
                        loginPlaceholder: "loginVC.modalPresent.loginTextField.placeholder".localized,
                        passwordPlaceholder: "loginVC.modalPresent.passwordTextField.placeholder".localized
                    )
                
                case .userIsLoggedIn:
                    print("log In ❤️‍🩹")
                    
                case .error(let error):
                    print(error)
                }
            }
        }
    }
//MARK: - 2.Life cycle
    
    override func loadView() {
        super.loadView()
        
        view = logInView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didShowKeyboard),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didHideKeyboard),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
//MARK: - 3.Methods
    
    private func setupUi() {
        
        self.view.backgroundColor = .secondarySystemBackground
        self.navigationController?.navigationBar.isHidden = true
        
        self.setupGestures()
        
    }
    
    private func setupGestures() {
        let tapGestures = UITapGestureRecognizer(target: self, action: #selector(self.forcedHidingKeyboard))
        self.view.addGestureRecognizer(tapGestures)
    }
    
    
    
    private func showAlert() {
        let alertController = UIAlertController(
            title: nil,
            message: "loginVC.alert.message".localized,
            preferredStyle: .alert
        )
        
        let singInAction = UIAlertAction(
            title: "loginVC.logInButton.setTitle".localized,
            style: .default,
            handler: { _ in
                self.dismiss(animated: true)
//                self.coordinator?.showProfileVC()
                print("alert Пользователь сохранен")
            }
        )
        
        alertController.addAction(singInAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @objc private func didShowKeyboard(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height

            let loginButtonBottom = self.logInView.loginButtomBottom()

            let keyboardOriginY = self.view.frame.height - keyboardHeight
            let yOffset = keyboardOriginY < loginButtonBottom
            ? loginButtonBottom - keyboardOriginY + 16
            : 0

            self.logInView.scrollView.contentOffset = CGPoint(x: 0, y: yOffset)
        }
    }
    
    @objc private func didHideKeyboard(_ notification: Notification) {
        self.forcedHidingKeyboard()
    }

    @objc private func forcedHidingKeyboard() {
        self.view.endEditing(true)
        self.logInView.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}

@available(iOS 15.0, *)
extension LogInViewController: LogInViewDelegate {
    
    func showProfileViewControllerButton() {
        
        let login = self.logInView.getLoginAndPassword().0
        let password = self.logInView.getLoginAndPassword().1
        
        let user = LogInUser(
            login: login,
            password: password
        )

       if isModal {
           self.viewModel?.updateState(viewInput: .newUserRegistration(user: user))

//           self.viewModel?.updateState(viewInput: .singIn(user: user))
//           checkerService.singUp(
//                withEmail: user.login,
//                password: user.password,
//                vc: self
//           ) { result in
//               switch result {
//               case .success:
//                   print("пользователь добавлен в firebase")
//                   self.createUserRealm(user: user)
//                   self.showAlert()
//               case .failure(let error):
//                   print("ошибка в firebase: ", error)
//               }
//           }
       } else {
//           checkerService.checkCredentials(
//                withEmail: user.login,
//                password: user.password,
//                vc: self
//           ) { result in
//               switch result {
//               case .success:
//                   print("логин и пароль верные -> открытие профиля")
//                   self.createUserRealm(user: user)
//                   self.coordinator?.showProfileVC()
           self.viewModel?.updateState(viewInput: .singIn(user: user))
        
//               case .failure(let error):
//                   print("ошибка в логине или пароле", error)
//               }
//           }
       }
    }
    
    func showRegistration() {
        viewModel?.updateState(viewInput: .showRegistration)
    }
}
