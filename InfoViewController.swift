//
//  InfoViewController.swift
//  Navigation
//
//  Created by Андрей Банин on 19.10.22..
//

import UIKit

class InfoViewController: UIViewController {
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("click", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .purple
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .yellow
        
        addTargets()
        setupConstraints()
        setupAlertController()
    }
    
    func addTargets() {
        button.addTarget(self, action: #selector(addTarget), for: .touchUpInside)
    }
    
    func setupConstraints() {
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    let alertController = UIAlertController(title: "Question", message: "red or blue", preferredStyle: .alert)
    
    func setupAlertController() {
        alertController.addAction(UIAlertAction(title: "red", style: .default, handler: { _ in
            print("left button")
        }))
        alertController.addAction(UIAlertAction(title: "blue", style: .default, handler: { _ in
            print("right button")
        }))
    }
    
    @objc func addTarget () {
        self.present(alertController, animated: true, completion: nil)
    }
}
