

import Foundation
import UIKit

@available(iOS 16.0, *)
class LikePostsCoordinator: AppCoordinator {
    
    weak var parentCoordinator: AppCoordinator?
    
    var child: [AppCoordinator] = []
    
    var navigationController: UINavigationController
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        self.showDocumentsVC()
    }
    
    private func showDocumentsVC() {
        let likePosts = LikePostsViewController()
        
        likePosts.coordinator = self
        navigationController.pushViewController(likePosts, animated: false)
    }
}
