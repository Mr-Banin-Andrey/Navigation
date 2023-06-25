

import Foundation
import UIKit

class AudioPlayerCoordinator: AppCoordinator {
    
    weak var parentCoordinator: AppCoordinator?
    
    var child: [AppCoordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showAudioPlayer()
    }
    
    func showAudioPlayer() {
        let audioPlayerVC = AudioPlayerViewController()
        audioPlayerVC.coordinator = self
        navigationController.pushViewController(audioPlayerVC, animated: false)
    }
}
