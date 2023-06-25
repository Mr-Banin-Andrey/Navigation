
import Foundation
import UIKit

class MapKitCoordinator: AppCoordinator {
    
    weak var parentCoordinator: AppCoordinator?
    
    var child: [AppCoordinator] = []
    
    var navigationController: UINavigationController
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        self.showMapKitVc()
    }
    
    func showMapKitVc() {
        let mapKitVc = MapKitViewController()
                
        mapKitVc.coordinator = self
        navigationController.pushViewController(mapKitVc, animated: true)
    }
}
