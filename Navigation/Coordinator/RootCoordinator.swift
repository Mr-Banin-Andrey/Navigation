//
//  RootCoordinator.swift
//  Navigation
//
//  Created by Андрей Банин on 17.3.23..
//

import Foundation
import UIKit

class RootCoordinator: AppCoordinator {
    
    private weak var transitionHandler: UITabBarController?
    
    
    var child: [AppCoordinator] = []
    
    
    init(
        transitionHandler: UITabBarController
    ) {
        self.transitionHandler = transitionHandler
    }
    
    func start() {
        showTabBar()
    }
    
    fileprivate func showTabBar() {
//       let tabBar = TabBarNavigationCoordinator()
        
    }
}
