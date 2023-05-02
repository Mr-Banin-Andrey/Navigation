//
//  LogInViewController.swift
//  Navigation
//
//  Created by Андрей Банин on 2.12.22..
//

import UIKit

protocol LoginViewControllerDelegate {
    func isCheck(_ sender: LogInViewController, login: String, password: String) -> Bool
}

struct LoginInspector: LoginViewControllerDelegate {
    func isCheck(_ sender: LogInViewController, login: String, password: String) -> Bool {
        return Checker.shared.isCheck(sender, login: login, password: password)
    }
}

class LogInViewController: UIViewController {
    
    var coordinator: ProfileCoordinator?
    
    var loginDelegate: LoginViewControllerDelegate?
    
//MARK: - 1. Properties
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
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
        view.backgroundColor = .systemGray6
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
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
    
    lazy var loginTextField: UITextField = {
        let login = UITextField()
        login.placeholder = "Email of phone"
        login.font = UIFont.systemFont(ofSize: 16)
        login.autocapitalizationType = .none
        login.textColor = .black
        login.translatesAutoresizingMaskIntoConstraints = false
        return login
    }()
    
    lazy var passwordTextField: UITextField = {
        let password = UITextField()
        password.placeholder = "Password"
        password.font = UIFont.systemFont(ofSize: 16)
        password.autocapitalizationType = .none
        password.textColor = .black
        password.isSecureTextEntry = true
        password.translatesAutoresizingMaskIntoConstraints = false
        return password
    }()
    
    private lazy var logInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "blueColor")
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showProfileViewController), for: .touchUpInside)
        return button
    }()
    
    private lazy var lineView: UIView = {
        let line = UIView()
        line.layer.borderWidth = 0.5
        line.layer.borderColor = UIColor.lightGray.cgColor
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
        
    private lazy var alertController: UIAlertController = {
        let alert = UIAlertController(title: "Ошибка", message: "Неверный логин или пароль", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Попробуй ещё раз", style: .default, handler: { _ in
            print("login invalid")
        }))
        return alert
    }()
    
    private lazy var pickUpPassword: CustomButton = {
        let button = CustomButton(title: "Подобрать пароль", bgColor: .green) { [unowned self] in
            
            self.passwordGuessQueue()
        }
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var nameQueue = DispatchQueue(label: "ru.navigation", qos: .userInteractive, attributes: [.concurrent])
    
//MARK: - 2.Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        
        self.setupGestures()
        self.setupConstraints()
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
    private func setupConstraints() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.logoImageView)
        self.scrollView.addSubview(self.loginPasswordView)
        self.scrollView.addSubview(self.lineView)
        self.scrollView.addSubview(self.loginPasswordStack)
        self.loginPasswordStack.addArrangedSubview(self.loginTextField)
        self.loginPasswordStack.addArrangedSubview(self.passwordTextField)
        self.scrollView.addSubview(self.logInButton)
        self.scrollView.addSubview(self.pickUpPassword)
        self.scrollView.addSubview(self.activityIndicator)
        
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            self.logoImageView.heightAnchor.constraint(equalToConstant: 100),
            self.logoImageView.widthAnchor.constraint(equalToConstant: 100),
            self.logoImageView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor),
            self.logoImageView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 120),
            
            self.loginPasswordView.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 120),
            self.loginPasswordView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.loginPasswordView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
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
            self.logInButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.logInButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            
            self.pickUpPassword.heightAnchor.constraint(equalToConstant: 30),
            self.pickUpPassword.topAnchor.constraint(equalTo: self.logInButton.bottomAnchor, constant: 16),
            self.pickUpPassword.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor),
            
            self.activityIndicator.bottomAnchor.constraint(equalTo: self.loginPasswordStack.bottomAnchor, constant: -8),
            self.activityIndicator.leadingAnchor.constraint(equalTo: self.loginPasswordStack.leadingAnchor)
        ])
    }
    
    private func setupGestures() {
        let tapGestures = UITapGestureRecognizer(target: self, action: #selector(self.forcedHidingKeyboard))
        self.view.addGestureRecognizer(tapGestures)
    }
    
    
    private func bruteForce(passwordToUnlock: String) -> String {
        
        let bruteForce = BruteForce()
        let ALLOWED_CHARACTERS: [String] = String().printable.map { String($0) }

        var password: String = ""

        while password != passwordToUnlock {
            password = bruteForce.generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
        }
        
        print(password)

        return password
    }
    
    private func randomPassword() -> String {
        var randomSymbolArray: [Character] = []
        
        countSymbol: while randomSymbolArray.count != 4 {
            switch randomSymbolArray.count {
            case 0,1,2,3:
                let symbol = (String().letters + String().digits).randomElement()
                randomSymbolArray.append(symbol ?? "-")
                continue countSymbol
            default:
                break countSymbol
            }
        }
        
        let randomSymbol = String(randomSymbolArray)
        print("\(randomSymbol) - randomSymbol")
        return randomSymbol
    }
    
    private func passwordGuessQueue() {
        let randomPassword = randomPassword()
        var bruteForceWord = ""
        passwordTextField.placeholder = nil
        passwordTextField.text = nil
        activityIndicator.startAnimating()
        passwordTextField.isEnabled = false
        pickUpPassword.isEnabled = false
        nameQueue.async { [weak self] in
            bruteForceWord = self?.bruteForce(passwordToUnlock: randomPassword) ?? ""
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.isHidden = true
                self?.passwordTextField.isSecureTextEntry = false
                self?.passwordTextField.text = bruteForceWord
                self?.passwordTextField.isEnabled = true
                self?.pickUpPassword.isEnabled = true
            }
        }
    }
    
    @objc func showAlert() {
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func didShowKeyboard(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            let loginButtonBottom = self.loginPasswordView.frame.origin.y + self.loginPasswordView.frame.height + 16 + self.logInButton.frame.height + 16 + self.pickUpPassword.frame.height
            
            let keyboardOriginY = self.view.frame.height - keyboardHeight
            let yOffset = keyboardOriginY < loginButtonBottom
            ? loginButtonBottom - keyboardOriginY + 16
            : 0
            
            self.scrollView.contentOffset = CGPoint(x: 0, y: yOffset)
        }
    }
    
    @objc private func didHideKeyboard(_ notification: Notification) {
        self.forcedHidingKeyboard()
    }
    
    @objc private func forcedHidingKeyboard() {
        self.view.endEditing(true)
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @objc func showProfileViewController() {

        let check = loginDelegate?.isCheck(self, login: loginTextField.text ?? "000", password: passwordTextField.text ?? "111")

        if check == true {
            coordinator?.showProfileVC()
        } else {
            showAlert()
        }
    }
}
