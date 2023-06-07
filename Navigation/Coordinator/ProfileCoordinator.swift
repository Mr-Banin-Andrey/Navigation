

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
    }
    
    func showProfileVC() {
        let profileVC = ProfileViewController()
                
        profileVC.coordinator = self
        navigationController.pushViewController(profileVC, animated: true)
    }
    
    func showPhotosVC() {
        let photosVC = PhotosViewController()
        
        photosVC.coordinator = self
        navigationController.pushViewController(photosVC, animated: true)
    }
    
    func showRegistration() {
        let logInVC = LogInViewController()

        logInVC.coordinator = self
        navigationController.present(logInVC, animated: true)
    }
}
