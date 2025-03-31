//
//  SceneDelegate.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 4/1/25.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let rootViewController = makeRootViewController()
        window.rootViewController = rootViewController
        self.window = window
        window.makeKeyAndVisible()
    }
}

private extension SceneDelegate {
    func makeRootViewController() -> UITabBarController {
        let tabBarController = UITabBarController()
        
        let homeVC = ADHomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house.fill"), selectedImage: nil)
        
        tabBarController.viewControllers = [homeVC]
        return tabBarController
    }
}
