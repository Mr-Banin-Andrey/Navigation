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
    
    private let firstButton: UIButton = {
        let firstButton = UIButton()
        firstButton.setTitle("Show window", for: .normal)
        firstButton.setTitleColor(UIColor.white, for: .normal)
        firstButton.backgroundColor = #colorLiteral(red: 0.042927064, green: 0.5177074075, blue: 1, alpha: 1)
        return firstButton
    }()
    
    private let secondButton: UIButton = {
        let secondButton = UIButton()
        secondButton.setTitle("Show window", for: .normal)
        secondButton.setTitleColor(UIColor.white, for: .normal)
        secondButton.backgroundColor = #colorLiteral(red: 0.042927064, green: 0.5177074075, blue: 1, alpha: 1)
        return secondButton
    }()
    
    //MARK: - 2. Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        setupConstraints()
        addTarget()
    }
    
    //MARK: - 3. Methods
    func addTarget () {
        firstButton.addTarget(self, action: #selector(showDetailController), for: .touchUpInside)
        secondButton.addTarget(self, action: #selector(showDetailController), for: .touchUpInside)
    }
    
    func setupConstraints(){
        view.addSubview(label)
        view.addSubview(twoButtons)
        twoButtons.addArrangedSubview(firstButton)
        twoButtons.addArrangedSubview(secondButton)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 65),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            twoButtons.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            twoButtons.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func showDetailController() {
        let detailController = PostViewController()
        navigationController?.pushViewController(detailController, animated: true)
    }
}
