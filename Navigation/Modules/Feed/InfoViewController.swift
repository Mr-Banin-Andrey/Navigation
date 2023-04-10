//
//  InfoViewController.swift
//  Navigation
//
//  Created by Андрей Банин on 19.10.22..
//

import UIKit

class InfoViewController: UIViewController {
    
    //MARK: - 1. Properties
    private lazy var button: CustomButton = {
        let button = CustomButton(title: "click", bgColor: .blue) { [unowned self] in
            self.present(alertController, animated: true, completion: nil)
        }
        return button
    }()
    
    let alertController = UIAlertController(title: "Question", message: "red or blue", preferredStyle: .alert)
    
    weak var coordinator: FeedCoordinator?
    
    //MARK: - 2. Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        
        setupConstraints()
        setupAlertController()
    }
    
    //MARK: - 3. Methods
    func setupConstraints() {
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setupAlertController() {
        alertController.addAction(UIAlertAction(title: "red", style: .default, handler: { _ in
            print("left button")
        }))
        alertController.addAction(UIAlertAction(title: "blue", style: .default, handler: { _ in
            print("right button")
        }))
    }
}
