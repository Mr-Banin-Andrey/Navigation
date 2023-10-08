

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
        
//        let documentsNC = UINavigationController()
//        let documentsCoordinator = DocumentsCoordinator(navigationController: documentsNC)
        
        let likePostsNC = UINavigationController()
        let likePostsCoordinator = LikePostsCoordinator(navigationController: likePostsNC)
        
        let mapKitNc = UINavigationController()
        let mapKitCoordinator = MapKitCoordinator(navigationController: mapKitNc)
        
        feedCoordinator.parentCoordinator = parentCoordinator
        profileCoordinator.parentCoordinator = parentCoordinator
        audioPlayerCoordinator.parentCoordinator = parentCoordinator
//        documentsCoordinator.parentCoordinator = parentCoordinator
        likePostsCoordinator.parentCoordinator = parentCoordinator
        mapKitCoordinator.parentCoordinator = parentCoordinator
        
        
        let feed = "viewController.title.feed".localized
        let profile = "tabBarItem.title.profile".localized
        let music = "tabBarItem.title.audioPlayer".localized
        let likePosts = "viewController.title.likePosts".localized
        let maps = "viewController.title.maps".localized
        
        
        let userFeedItem = UITabBarItem(title: feed, image: UIImage(systemName: "newspaper"), tag: 0)
        let userProfileItem = UITabBarItem(title: profile, image: UIImage(systemName: "person"), tag: 1)
        let audioPlayerItem = UITabBarItem(title: music, image: UIImage(systemName: "music.quarternote.3"), tag: 2)
//        let documentsItem = UITabBarItem(title: "Documents", image: UIImage(systemName: "doc.text"), tag: 3)
        let likePostsItem = UITabBarItem(title: likePosts, image: UIImage(systemName: "hand.thumbsup"), tag: 4)
        let mapKitItem = UITabBarItem(title: maps, image: UIImage(systemName: "map"), tag: 5)
        
        UITabBar.appearance().tintColor = #colorLiteral(red: 0.042927064, green: 0.5177074075, blue: 1, alpha: 1)
        UITabBar.appearance().backgroundColor = .systemBackground
        
        feedNC.tabBarItem = userFeedItem
        profileNC.tabBarItem = userProfileItem
        audioPlayerNC.tabBarItem = audioPlayerItem
//        documentsNC.tabBarItem = documentsItem
        likePostsNC.tabBarItem = likePostsItem
        mapKitNc.tabBarItem = mapKitItem
        
        tabBarCont.viewControllers = [feedNC, mapKitNc, profileNC, likePostsNC, audioPlayerNC]
        navigationController.pushViewController(tabBarCont, animated: true)
        navigationController.setNavigationBarHidden(true, animated: true)
        
        parentCoordinator?.child.append(feedCoordinator)
        parentCoordinator?.child.append(profileCoordinator)
        parentCoordinator?.child.append(audioPlayerCoordinator)
//        parentCoordinator?.child.append(documentsCoordinator)
        parentCoordinator?.child.append(likePostsCoordinator)
        parentCoordinator?.child.append(mapKitCoordinator)
        
        feedCoordinator.start()
        profileCoordinator.start()
        audioPlayerCoordinator.start()
//        documentsCoordinator.start()
        likePostsCoordinator.start()
        mapKitCoordinator.start()
    }
}
