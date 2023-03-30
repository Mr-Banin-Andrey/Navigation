//
//  FeedViewController.swift
//  Navigation
//
//  Created by Андрей Банин on 18.10.22..
//

import UIKit

class FeedViewController: UIViewController {
   
    var coordinator: FeedCoordinator?
    
    //MARK: - 1. Properties
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Feed"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var twoButtons: UIStackView = {
        let twoButtons = UIStackView()
        twoButtons.axis = .vertical
        twoButtons.spacing = 10
        twoButtons.translatesAutoresizingMaskIntoConstraints = false
        return twoButtons
    }()
    
    private lazy var firstButton: CustomButton = {
        let button = CustomButton(title: "Show Post", bgColor: #colorLiteral(red: 0.042927064, green: 0.5177074075, blue: 1, alpha: 1)) { [unowned self] in
            
            coordinator?.showPostVC()
//            let showVC = PostViewController()
//            navigationController?.pushViewController(showVC, animated: true)
        }
        return button
    }()
    
    private lazy var secondButton: CustomButton = {
        let button = CustomButton(title: "Show Info", bgColor: #colorLiteral(red: 0.042927064, green: 0.5177074075, blue: 1, alpha: 1)) { [unowned self] in
            
            coordinator?.showInfoVC()
//            let showVC = PostViewController()
//            navigationController?.pushViewController(showVC, animated: true)
        }
        return button
    }()
    
    private lazy var textCheck: UITextField = {
        let textStatus = UITextField()
        textStatus.placeholder = " Text Check "
        textStatus.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textStatus.backgroundColor = .white
        textStatus.translatesAutoresizingMaskIntoConstraints = false
        return textStatus
    }()
    
    private lazy var checkGuessButton: CustomButton = {
                
        let button = CustomButton(title: "Check guess", bgColor: .blue) { [unowned self] in
            
            guard let word = textCheck.text else { return }
            
            let isCheck = FeedModel().isCheck(word: word)
            checkLabel.text = isCheck.text
            checkLabel.backgroundColor = isCheck.color
        }
        return button
    }()
    
    private lazy var checkLabel: UILabel = {
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
}
