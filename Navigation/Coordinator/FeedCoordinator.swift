//
//  FeedCoordinator.swift
//  Navigation
//
//  Created by Андрей Банин on 19.3.23..
//

import Foundation
import UIKit

class FeedCoordinator: AppCoordinator {
    
    weak var parentCoordinator: AppCoordinator?
    
    var child: [AppCoordinator] = []
    
    var navigationController: UINavigationController
    
    func start() {
        showFeedVC()
    }
    
    private func showFeedVC() {

        let feedVC = FeedViewController()
        navigationController.pushViewController(feedVC, animated: false)
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
