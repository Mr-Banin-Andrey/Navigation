

import Foundation
import UIKit

@available(iOS 15.0, *)
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
        let viewModel = LogInViewModel()
        let logInVC = LogInViewController(logInViewModelProtocol: viewModel)
        let myLF = MyLoginFactory()
        
//        logInVC.viewModel = viewModel
        logInVC.loginDelegate = myLF.makeLoginInspector()
        viewModel.coordinator = self
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
        let viewModel = LogInViewModel()
        let logInVC = LogInViewController(logInViewModelProtocol: viewModel)

//        logInVC.viewModel = viewModel
        viewModel.coordinator = self
        navigationController.present(logInVC, animated: true)
    }
}
