//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Андрей Банин on 18.10.22..
//

import UIKit

class ProfileViewController: UIViewController {
    
    //MARK: - 1. Properties
    private let profileHeaderView: ProfileHeaderView = ProfileHeaderView()
    
    private let newButton: UIButton = {
        let newButton = UIButton()
        newButton.setTitle("какая-то кнопка", for: .normal)
        newButton.setTitleColor(UIColor.white, for: .normal)
        newButton.backgroundColor = #colorLiteral(red: 0, green: 0.4780646563, blue: 0.9985368848, alpha: 1)
        newButton.translatesAutoresizingMaskIntoConstraints = false
        return newButton
    }()
    
    //MARK: - 2. Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        viewSetupConstraints()
        
        self.navigationItem.title = "Profile"
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    //MARK: - 3. Methods
    private func viewSetupConstraints() {
        
        view.addSubview(profileHeaderView)
        view.addSubview(newButton)
        
        NSLayoutConstraint.activate([
            profileHeaderView.topAnchor.constraint(equalTo: view.topAnchor),
            profileHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            newButton.heightAnchor.constraint(equalToConstant: 30),
            newButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            newButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            newButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}
