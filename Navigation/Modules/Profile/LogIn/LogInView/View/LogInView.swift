
import Foundation
import UIKit

protocol LogInViewDelegate: AnyObject {
    func showProfileViewControllerButton()
    func showRegistration()
}

class LogInView: UIView {
    
    private weak var delegate: LogInViewDelegate?
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .secondarySystemBackground
        return scrollView
    }()
    
    private lazy var logoImageView: UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(named: "logo")
        logo.translatesAutoresizingMaskIntoConstraints = false
        return logo
    }()
    
    private lazy var loginPasswordView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemBackground
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.opaqueSeparator.cgColor
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var loginPasswordStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var loginTextField: UITextField = {
        let login = UITextField()
//        login.placeholder = "E-mail"
        login.font = UIFont.systemFont(ofSize: 16)
        login.autocapitalizationType = .none
        login.translatesAutoresizingMaskIntoConstraints = false
        login.keyboardType = .emailAddress
        login.backgroundColor = .tertiarySystemBackground
        return login
    }()
    
    private lazy var passwordTextField: UITextField = {
        let password = UITextField()
//        password.placeholder = "loginVC.passwordTextField.placeholder".localized
        password.font = UIFont.systemFont(ofSize: 16)
        password.autocapitalizationType = .none
        password.isSecureTextEntry = true
        password.translatesAutoresizingMaskIntoConstraints = false
        password.backgroundColor = .tertiarySystemBackground
        return password
    }()
    
    private lazy var logInButton: UIButton = {
        let button = UIButton()
//        button.setTitle("loginVC.logInButton.setTitle".localized,
//                        for: .normal)
        button.setTitleColor(UIColor.createColor(lightMode: .white, darkMode: .black),
                             for: .normal)
        button.backgroundColor = UIColor(named: "blueColor")
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showProfileViewControllerButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var lineView: UIView = {
        let line = UIView()
        line.layer.borderWidth = 0.5
        line.layer.borderColor = UIColor.opaqueSeparator.cgColor
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    private lazy var singUpButton: CustomButton = {
        let button = CustomButton(
            title: "loginVC.singUpButton.title".localized,
            titleColor: UIColor.createColor(lightMode: .white, darkMode: .black),
            bgColor: UIColor(named: "blueColor") ?? UIColor.red
        ) { [unowned self] in
            self.showRegistration()
//            self.passwordGuessQueue()
        }
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var nameQueue = DispatchQueue(label: "ru.navigation", qos: .userInteractive, attributes: [.concurrent])
    
    
    init(delegate: LogInViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        self.addSubview(self.scrollView)
        self.scrollView.addSubview(self.logoImageView)
        self.scrollView.addSubview(self.loginPasswordView)
        self.scrollView.addSubview(self.lineView)
        self.scrollView.addSubview(self.loginPasswordStack)
        self.loginPasswordStack.addArrangedSubview(self.loginTextField)
        self.loginPasswordStack.addArrangedSubview(self.passwordTextField)
        self.scrollView.addSubview(self.logInButton)
        self.scrollView.addSubview(self.singUpButton)
        self.scrollView.addSubview(self.activityIndicator)
        
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            self.logoImageView.heightAnchor.constraint(equalToConstant: 100),
            self.logoImageView.widthAnchor.constraint(equalToConstant: 100),
            self.logoImageView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor),
            self.logoImageView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 120),
            
            self.loginPasswordView.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 100),
            self.loginPasswordView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.loginPasswordView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.loginPasswordView.heightAnchor.constraint(equalToConstant: 100),
            
            self.lineView.heightAnchor.constraint(equalToConstant: 0.5),
            self.lineView.topAnchor.constraint(equalTo: self.loginPasswordView.topAnchor, constant: 50),
            self.lineView.leadingAnchor.constraint(equalTo: self.loginPasswordView.leadingAnchor),
            self.lineView.trailingAnchor.constraint(equalTo: self.loginPasswordView.trailingAnchor),
            
            self.loginPasswordStack.leadingAnchor.constraint(equalTo: self.loginPasswordView.leadingAnchor, constant: 10),
            self.loginPasswordStack.trailingAnchor.constraint(equalTo: self.loginPasswordView.trailingAnchor, constant: -10),
            self.loginPasswordStack.topAnchor.constraint(equalTo: self.loginPasswordView.topAnchor, constant: 5),
            self.loginPasswordStack.bottomAnchor.constraint(equalTo: self.loginPasswordView.bottomAnchor, constant: -5),
            
            self.logInButton.heightAnchor.constraint(equalToConstant: 50),
            self.logInButton.topAnchor.constraint(equalTo: self.loginPasswordView.bottomAnchor, constant: 16),
            self.logInButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.logInButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            self.singUpButton.heightAnchor.constraint(equalToConstant: 30),
            self.singUpButton.topAnchor.constraint(equalTo: self.logInButton.bottomAnchor, constant: 16),
            self.singUpButton.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor),
            
            self.activityIndicator.bottomAnchor.constraint(equalTo: self.loginPasswordStack.bottomAnchor, constant: -8),
            self.activityIndicator.leadingAnchor.constraint(equalTo: self.loginPasswordStack.leadingAnchor)
        ])
    }
    
    
    func setupTitleAndPlaceholder(hidden: Bool, buttonTitle: String, loginPlaceholder: String, passwordPlaceholder: String) {
        self.singUpButton.isHidden = hidden
        self.logInButton.setTitle(buttonTitle, for: .normal)
        self.passwordTextField.placeholder = passwordPlaceholder
        self.loginTextField.placeholder = loginPlaceholder
    }
    
    func loginButtomBottom() -> CGFloat {
        let loginButtomBottom = self.loginPasswordView.frame.origin.y + self.loginPasswordView.frame.height + 16 + self.logInButton.frame.height + 16 + self.singUpButton.frame.height
        return loginButtomBottom
    }
    
    //вынести во ViewModel
    func autoAuth() {
        let arrayUsers = RealmService().fetch()
        print( arrayUsers )
        guard arrayUsers.isEmpty == false else { return }

        self.loginTextField.text = arrayUsers[0].login
        self.passwordTextField.text = arrayUsers[0].password

        showProfileViewControllerButton()
    }
    
    func getLoginAndPassword() -> (String, String) {
        guard
            let login = self.loginTextField.text,
            let password = self.passwordTextField.text
        else { return ("", "") }
        return (login, password)
    }
    
    func showAlertEmptyFields(vc: UIViewController) {
        let alertController = UIAlertController(
            title: "universalMeaning.alert.title".localized,
            message: "firebase.checkerService.alert.cellEmpty.message".localized,
            preferredStyle: .alert
        )
        
        let singInAction = UIAlertAction(
            title: "universalMeaning.Button.tryAgain".localized,
            style: .default
        )
        
        alertController.addAction(singInAction)
        vc.present(alertController, animated: true)
    }
    
    private func passwordGuessQueue() {
        let useBruteForce = UseBruteForce()
        let randomPassword = useBruteForce.randomPassword()
        var bruteForceWord = ""
        passwordTextField.placeholder = nil
        passwordTextField.text = nil
        activityIndicator.startAnimating()
        passwordTextField.isEnabled = false
        singUpButton.isEnabled = false
        nameQueue.async { [weak self] in
            bruteForceWord = useBruteForce.bruteForce(passwordToUnlock: randomPassword)
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.isHidden = true
                self?.passwordTextField.isSecureTextEntry = false
                self?.passwordTextField.text = bruteForceWord
                self?.passwordTextField.isEnabled = true
                self?.singUpButton.isEnabled = true
            }
        }
    }
    
    @objc private func showProfileViewControllerButton() {
        delegate?.showProfileViewControllerButton()
    }
    
    @objc private func showRegistration() {
        delegate?.showRegistration()
    }
}
