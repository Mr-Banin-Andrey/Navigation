//
//  ProfileCoordinator.swift
//  Navigation
//
//  Created by Андрей Банин on 19.3.23..
//

import Foundation
import UIKit

class ProfileCoordinator: AppCoordinator {
    
    weak var parentCoordinator: AppCoordinator?
    
    var child: [AppCoordinator] = []
    
    var navigationController: UINavigationController
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showLogInVC()
    }
    
    func showLogInVC() {
        let logInVC = LogInViewController()
        let myLF = MyLoginFactory()

        logInVC.loginDelegate = myLF.makeLoginInspector()
        logInVC.coordinator = self
        navigationController.pushViewController(logInVC, animated: false)
        print("ProfileCoordinator")
    }
    
    func showProfileVC() {
        let profileVC = ProfileViewController()
                
        profileVC.coordinator = self
        navigationController.pushViewController(profileVC, animated: true)
        print("showProfileVC()")
    }
    
    func showPhotosVC() {
        let photosVC = PhotosViewController()
        
        photosVC.coordinator = self
        navigationController.pushViewController(photosVC, animated: false)
    }
    
}
