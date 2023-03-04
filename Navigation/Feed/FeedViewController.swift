//
//  FeedViewController.swift
//  Navigation
//
//  Created by Андрей Банин on 18.10.22..
//

import UIKit

class FeedViewController: UIViewController {
   
    //MARK: - 1. Properties
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Заголовок 1"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let twoButtons: UIStackView = {
        let twoButtons = UIStackView()
        twoButtons.axis = .vertical
        twoButtons.spacing = 10
        twoButtons.translatesAutoresizingMaskIntoConstraints = false
        return twoButtons
    }()
    
    private let firstButton: CustomButton = {
        let firstButton = CustomButton(title: "Show First")
        firstButton.addTarget(self, action: #selector(showPostVC), for: .touchUpInside)
        return firstButton
    }()
    
    private let secondButton: CustomButton = {
        let secondButton = CustomButton(title: "Show Second")
        secondButton.addTarget(self, action: #selector(showPostVC), for: .touchUpInside)
        return secondButton
    }()
    
    private lazy var textCheck: UITextField = {
        let textStatus = UITextField()
        textStatus.placeholder = " Text Check "
        textStatus.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textStatus.backgroundColor = .white
        textStatus.translatesAutoresizingMaskIntoConstraints = false
        return textStatus
    }()
    
    private let checkGuessButton: CustomButton = {
        let secondButton = CustomButton(title: "Check guess")
        secondButton.addTarget(self, action: #selector(checkGuess), for: .touchUpInside)
        return secondButton
    }()
    
    private let checkLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    //MARK: - 2. Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        setupConstraints()
    }
    
    //MARK: - 3. Methods
    func setupConstraints(){
        view.addSubview(label)
        view.addSubview(twoButtons)
        twoButtons.addArrangedSubview(firstButton)
        twoButtons.addArrangedSubview(secondButton)
        view.addSubview(self.textCheck)
        view.addSubview(self.checkGuessButton)
        view.addSubview(self.checkLabel)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 65),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            twoButtons.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            twoButtons.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            
            textCheck.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textCheck.topAnchor.constraint(equalTo: twoButtons.bottomAnchor, constant: 200),
            textCheck.widthAnchor.constraint(equalToConstant: 150),
            textCheck.heightAnchor.constraint(equalToConstant: 30),
            
            checkGuessButton.topAnchor.constraint(equalTo: textCheck.bottomAnchor, constant: 25),
            checkGuessButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            checkLabel.topAnchor.constraint(equalTo: twoButtons.bottomAnchor, constant: 150),
            checkLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            checkLabel.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    @objc func showPostVC() {
        firstButton.buttonTapped(self, PostViewController())
    }
    
    @objc func checkGuess() {
        
        let feedModel = FeedModel()
        let isCheck = feedModel.isCheck(word: textCheck.text!)
        
        if isCheck == true {
            checkLabel.text = "  ВЕРНО ✔️  "
            checkLabel.backgroundColor = .systemGreen
        } else {
            checkLabel.text = "  НЕВЕРНО ✖️  "
            checkLabel.backgroundColor = .systemRed
        }
    }
}
