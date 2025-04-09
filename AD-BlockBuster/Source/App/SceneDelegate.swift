//
//  SceneDelegate.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 4/1/25.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var coordinator: (any Coordinator)?
    let navigationController = UINavigationController()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        setupNavigationBar()
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        startScene()
    }
}

private extension SceneDelegate {
    func startScene() {
        self.coordinator = AppCoordinator(navigationController: navigationController)
        coordinator?.start()
    }
    
    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.neutral,
            .font: UIFont.pretendard(size: 18, weight: .semibold)
        ]
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        
        let barButtonAppearance = UIBarButtonItemAppearance()
        barButtonAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.clear,
            .font: UIFont.systemFont(ofSize: .zero)
        ]
        
        let backButtonImage = UIImage(named: "left")?.withRenderingMode(.alwaysTemplate)
        appearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        
        navigationController.navigationBar.tintColor = .neutral
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
    }
}
