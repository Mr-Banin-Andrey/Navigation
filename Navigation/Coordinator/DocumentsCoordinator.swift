

import Foundation
import UIKit

class DocumentsCoordinator: AppCoordinator {
    
    weak var parentCoordinator: AppCoordinator?
    
    var child: [AppCoordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        self.showDocumentsVC()
    }
    
    func showDocumentsVC() {
        let documentsVC = DocumentsViewController()
        
        documentsVC.coordinator = self
        navigationController.pushViewController(documentsVC, animated: false)
    }
}
