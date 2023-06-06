

import Foundation
import UIKit

@available(iOS 16.0, *)
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
        
        let documentsNC = UINavigationController()
        let documentsCoordinator = DocumentsCoordinator(navigationController: documentsNC)
        
        feedCoordinator.parentCoordinator = parentCoordinator
        profileCoordinator.parentCoordinator = parentCoordinator
        audioPlayerCoordinator.parentCoordinator = parentCoordinator
        documentsCoordinator.parentCoordinator = parentCoordinator
        
        let userFeed = UITabBarItem(title: "Feed", image: UIImage(systemName: "newspaper"), tag: 0)
        let userProfile = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 1)
        let audioPlayer = UITabBarItem(title: "Music", image: UIImage(systemName: "music.quarternote.3"), tag: 2)
        let documents = UITabBarItem(title: "Documents", image: UIImage(systemName: "doc.text"), tag: 3)
        
        UITabBar.appearance().tintColor = #colorLiteral(red: 0.042927064, green: 0.5177074075, blue: 1, alpha: 1)
        UITabBar.appearance().backgroundColor = #colorLiteral(red: 0.9154649377, green: 0.9269897342, blue: 0.9267870188, alpha: 1)
        
        
        feedNC.tabBarItem = userFeed
        profileNC.tabBarItem = userProfile
        audioPlayerNC.tabBarItem = audioPlayer
        documentsNC.tabBarItem = documents
        
        tabBarCont.viewControllers = [documentsNC, feedNC, profileNC, audioPlayerNC]
        navigationController.pushViewController(tabBarCont, animated: true)
        navigationController.setNavigationBarHidden(true, animated: true)
        
        parentCoordinator?.child.append(feedCoordinator)
        parentCoordinator?.child.append(profileCoordinator)
        parentCoordinator?.child.append(audioPlayerCoordinator)
        parentCoordinator?.child.append(documentsCoordinator)
        
        feedCoordinator.start()
        profileCoordinator.start()
        audioPlayerCoordinator.start()
        documentsCoordinator.start()
    }
}
