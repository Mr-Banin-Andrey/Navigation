//
//  FeedViewController.swift
//  Navigation
//
//  Created by Андрей Банин on 18.10.22..
//

import UIKit

class FeedViewController: UIViewController {
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Заголовок 1"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("Just DO IT", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .orange
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupUI()
        
        view.backgroundColor = .green
        setupConstraints()
        addTarget()
    }
    
    
//    func setupUI() {
//        setupConstraints()
//        addTarget()
//    }
    
    func addTarget () {
        button.addTarget(self, action: #selector(showDetailController), for: .touchUpInside)
    }
    
    func setupConstraints(){
        
        view.addSubview(label)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 65),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func showDetailController() {
        let detailController = PostViewController()
        navigationController?.pushViewController(detailController, animated: true)
    }
}
