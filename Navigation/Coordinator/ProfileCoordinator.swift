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
    
    func start() {
        showProfileVC()
    }
    
    private func showProfileVC() {

        let profileVC = ProfileViewController()
        navigationController.pushViewController(profileVC, animated: false)
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
