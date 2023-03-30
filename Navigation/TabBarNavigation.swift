//
//  TabBarController.swift
//  Navigation
//
//  Created by Андрей Банин on 20.2.23..
//

import Foundation
import UIKit

//final class TabBarNavigation: UITabBarController {
//    
//    private var feedTabNavigationController: UIViewController!
//    private var profileTabNavigationController: UIViewController!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.setupTabBar()
//    }
//    
//    
//    private func setupTabBar() {
//        
//        let logInVC = LogInViewController()
//        let myLF = MyLoginFactory()
//        
//        logInVC.loginDelegate = myLF.makeLoginInspector()
//        
//        feedTabNavigationController = UINavigationController.init(rootViewController: FeedViewController())
//        profileTabNavigationController = UINavigationController(rootViewController: logInVC)
//        
//        self.viewControllers = [feedTabNavigationController, profileTabNavigationController]
//        
//        let userFeed = UITabBarItem(title: "Feed", image: UIImage(systemName: "newspaper"), tag: 0)
//        let userProfile = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 1)
//        
//        UITabBar.appearance().tintColor = #colorLiteral(red: 0.042927064, green: 0.5177074075, blue: 1, alpha: 1)
//        UITabBar.appearance().backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        
//        feedTabNavigationController.tabBarItem = userFeed
//        profileTabNavigationController.tabBarItem = userProfile
//    }
//}
