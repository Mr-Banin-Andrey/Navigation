

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
    
//MARK: - Properties

    var loginDelegate: LoginViewControllerDelegate?
    
    private lazy var logInView = LogInView(delegate: self)
    
    private let checkerService = CheckerService()
        
    private let viewModel: LogInViewModelProtocol

    
//MARK: - Initiation
    
    init(logInViewModelProtocol: LogInViewModelProtocol) {
        self.viewModel = logInViewModelProtocol
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - Life cycle
    
    override func loadView() {
        super.loadView()
        
        view = logInView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("🔋viewDidLoad")
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didShowKeyboard),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didHideKeyboard),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
//MARK: - Private methods
    
    private func setup() {
        self.setupGestures()
        self.view.backgroundColor = .secondarySystemBackground
        self.bindViewModel()
        
        if isModal {
            logInView.setupTitleAndPlaceholder(
                hidden: true,
                buttonTitle: "loginVC.modalPresent.logInButton.title".localized,
                loginPlaceholder: "loginVC.modalPresent.loginTextField.placeholder".localized,
                passwordPlaceholder: "loginVC.modalPresent.passwordTextField.placeholder".localized
            )
        } else {
            logInView.setupTitleAndPlaceholder(
                hidden: false,
                buttonTitle: "loginVC.logInButton.setTitle".localized,
                loginPlaceholder: "E-mail",
                passwordPlaceholder: "loginVC.passwordTextField.placeholder".localized
            )
            logInView.autoAuth()
        }
    }
    
    private func bindViewModel() {
        viewModel.onStateDidChange = { [weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .waitingForEntry:
                print("waitingForEntry")
                
            case .userIsNotAuthorized:
                print("userIsNotAuthorized")
            case .userIsAuthorized:
                print("userIsAuthorized")
                showAlert()
                
//            case .userIsLoggedIn:
//                print("userIsLoggedIn")
//            case .newUserRegistration:
//                print("newUserRegistration")
            
            case let .error(error):
                print("Error state: \(error)")
                
            }
        }
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
                self.viewModel.updateState(viewInput: .didNewUserRegistration)
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
        
        let user = LogInUser(login: login,password: password)

        if isModal {
           self.viewModel.updateState(viewInput: .willNewUserRegistration(user: user))
        } else {
           self.viewModel.updateState(viewInput: .singIn(user: user))
        }
    }
    
    func showRegistration() {
        viewModel.updateState(viewInput: .showWindowRegistration)
    }
}
