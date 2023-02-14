//
//  LogInViewController.swift
//  Navigation
//
//  Created by Андрей Банин on 2.12.22..
//

import UIKit

class LogInViewController: UIViewController {
    
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
    
    private lazy var loginTextField: UITextField = {
        let login = UITextField()
        login.placeholder = "Email of phone"
        login.font = UIFont.systemFont(ofSize: 16)
        login.autocapitalizationType = .none
        login.textColor = .black
        login.translatesAutoresizingMaskIntoConstraints = false
        return login
    }()
    
    private lazy var passwordTextField: UITextField = {
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
        return button
    }()
    
    private lazy var lineView: UIView = {
        let line = UIView()
        line.layer.borderWidth = 0.5
        line.layer.borderColor = UIColor.lightGray.cgColor
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    let alertController = UIAlertController(title: "Error", message: "login invalid", preferredStyle: .alert)
    
//MARK: - 2.Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        
        self.setupGestures()
        self.addTarget()
        self.setupAlertController()
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
            self.logInButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupGestures() {
        let tapGestures = UITapGestureRecognizer(target: self, action: #selector(self.forcedHidingKeyboard))
        self.view.addGestureRecognizer(tapGestures)
    }
    
    private func addTarget() {
        logInButton.addTarget(self, action: #selector(showProfileViewController), for: .touchUpInside)
    }
    
    func setupAlertController() {
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            print("login invalid")
        }))
    }
    
    @objc func showAlert () {
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func didShowKeyboard(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            let loginButtonBottom = self.loginPasswordView.frame.origin.y + self.loginPasswordView.frame.height + 16 + self.logInButton.frame.height
            
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
    
    @objc private func showProfileViewController() {
        
        let profileVC = ProfileViewController()
        
#if DEBUG
        let user = TestUserService(user: profileVC.userDebug).checkLogin(login: profileVC.userDebug)!

#else
        let user = CurrentUserService(user: profileVC.userRelease).checkLogin(login: profileVC.userRelease)!

#endif
        if loginTextField.text == user.login {
            profileVC.profileHV.setup(user: user)
            profileVC.userVar = user
            navigationController?.pushViewController(profileVC, animated: true)
        } else {
            showAlert()
        }
    }
}
