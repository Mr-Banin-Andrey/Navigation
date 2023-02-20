//
//  SceneDelegate.swift
//  Navigation
//
//  Created by Андрей Банин on 18.10.22..
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    //MARK: - 1. навигационные контроллеры
    
    var feedTabNavigationController: UIViewController!
    var profileTabNavigationController: UIViewController!

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }

        //MARK: - 2. Инициализируем таббар контроллер
        
        let tabBarController = UITabBarController()
        
        //MARK: - 3. напрямую создаем навигационные контроллеры
        
        let inspector = LoginInspector()
        let logInVC = LogInViewController()
        logInVC.loginDelegate = inspector
        
        feedTabNavigationController = UINavigationController.init(rootViewController: FeedViewController())
        profileTabNavigationController = UINavigationController(rootViewController: logInVC.self)
        
        //MARK: - 4. Заполняем контейнер с контроллерами таббара нашими навигационными контроллерами
        
        tabBarController.viewControllers = [feedTabNavigationController, profileTabNavigationController]
        
        //MARK: - 5. создание кнопок
        
        let userFeed = UITabBarItem(title: "Feed", image: UIImage(systemName: "newspaper"), tag: 0)
        let userProfile = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 1)
        
        //MARK: - 6. кастамизация кнопок
        
        UITabBar.appearance().tintColor = #colorLiteral(red: 0.042927064, green: 0.5177074075, blue: 1, alpha: 1)
        UITabBar.appearance().backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        //MARK: - 7. закрепляет кнопки
        
        feedTabNavigationController.tabBarItem = userFeed
        profileTabNavigationController.tabBarItem = userProfile
        
        //MARK: - 8. делает видимым экран, т к начальный сториборд удален
        
        let window = UIWindow(windowScene: windowScene)  //в строчке 23 даём название вместо _
        window.rootViewController = tabBarController
        
        self.window = window
        window.makeKeyAndVisible()
        
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

