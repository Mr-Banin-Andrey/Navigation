//
//  TabBarNavigationCoordinator.swift
//  Navigation
//
//  Created by Андрей Банин on 19.3.23..
//

import Foundation
import UIKit

class RootTabBarNavigationCoordinator: AppCoordinator {
    
    weak var parentCoordinator: AppCoordinator?
    var navigationController: UINavigationController
    
    var child: [AppCoordinator] = []

    // MARK: - Initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Func
    func start() {
        setupTabBar()
    }
    
    private func setupTabBar() {
        
        let tabBarCont = UITabBarController.init()
                
        let feedNC = UINavigationController()
        let feedCoordinator = FeedCoordinator(navigationController: feedNC)

        let profileNC = UINavigationController()
        let profileCoordinator = ProfileCoordinator(navigationController: profileNC)
        
        let audioPlayerNC = UINavigationController()
        let audioPlayerCoordinator = AudioPlayerCoordinator(navigationController: audioPlayerNC)
        
        feedCoordinator.parentCoordinator = parentCoordinator
        profileCoordinator.parentCoordinator = parentCoordinator
        audioPlayerCoordinator.parentCoordinator = parentCoordinator
        
        let userFeed = UITabBarItem(title: "Feed", image: UIImage(systemName: "newspaper"), tag: 0)
        let userProfile = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 1)
        let audioPlayer = UITabBarItem(title: "Music", image: UIImage(systemName: "music.quarternote.3"), tag: 2)
        
        UITabBar.appearance().tintColor = #colorLiteral(red: 0.042927064, green: 0.5177074075, blue: 1, alpha: 1)
        UITabBar.appearance().backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        feedNC.tabBarItem = userFeed
        profileNC.tabBarItem = userProfile
        audioPlayerNC.tabBarItem = audioPlayer
        
        tabBarCont.viewControllers = [feedNC, profileNC, audioPlayerNC]
        navigationController.pushViewController(tabBarCont, animated: true)
        navigationController.setNavigationBarHidden(true, animated: true)
        
        parentCoordinator?.child.append(feedCoordinator)
        parentCoordinator?.child.append(profileCoordinator)
        parentCoordinator?.child.append(audioPlayerCoordinator)
        
        feedCoordinator.start()
        profileCoordinator.start()
        audioPlayerCoordinator.start()
    }
}
