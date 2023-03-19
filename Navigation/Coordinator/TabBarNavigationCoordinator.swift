//
//  TabBarNavigationCoordinator.swift
//  Navigation
//
//  Created by Андрей Банин on 19.3.23..
//

import Foundation
import UIKit

class TabBarNavigationCoordinator: AppCoordinator {
    
    weak var parentCoordinator: AppCoordinator?
    var navigationController: UINavigationController
    
    var child: [AppCoordinator] = []
    
    func start() {
        setupTabBar()
    }
    
    private func setupTabBar() {
        
//        let navigationController = UINavigationController()
        let vc = UITabBarController.init()
        
//        let logInVC = LogInViewController()
//        let myLF = MyLoginFactory()
//
//        logInVC.loginDelegate = myLF.makeLoginInspector()
        
//        var feedTabNavigationController = UIViewController()
//        var profileTabNavigationController = UIViewController()
        
//        feedTabNavigationController = UINavigationController.init(rootViewController: FeedViewController())
//        profileTabNavigationController = UINavigationController.init(rootViewController: logInVC)
        
        let feedNC = UINavigationController()
        let feedCoordinator = FeedCoordinator.init(navigationController: feedNC)

        let profileNC = UINavigationController()
        let profileCoordinator = ProfileCoordinator.init(navigationController: profileNC)
        
        feedCoordinator.parentCoordinator = parentCoordinator
        profileCoordinator.parentCoordinator = parentCoordinator
        
        let userFeed = UITabBarItem(title: "Feed", image: UIImage(systemName: "newspaper"), tag: 0)
        let userProfile = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 1)
        
        UITabBar.appearance().tintColor = #colorLiteral(red: 0.042927064, green: 0.5177074075, blue: 1, alpha: 1)
        UITabBar.appearance().backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        feedNC.tabBarItem = userFeed
        profileNC.tabBarItem = userProfile
        
        vc.viewControllers = [feedNC, profileNC]
        navigationController.pushViewController(vc, animated: true)
        navigationController.setNavigationBarHidden(true, animated: true)
        
        parentCoordinator?.child.append(feedCoordinator)
        parentCoordinator?.child.append(profileCoordinator)
        
        feedCoordinator.start()
        profileCoordinator.start()
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
