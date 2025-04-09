//
//  AppCoordinator.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 4/2/25.
//

import UIKit

final class AppCoordinator: Coordinator {
    // MARK: - Properties
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    // MARK: - Initialize
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Methods
    func start() {
        if checkOnboardingCompletion() {
            showMainFlow()
        } else {
            showOnboardingFlow()
        }
    }
}

// MARK: - Private Methods
private extension AppCoordinator {
    func checkOnboardingCompletion() -> Bool {
        if UserDefaults.standard.bool(forKey: Constants.onboardingIdentifier) {
            return true
        } else {
            UserDefaults.standard.set(true, forKey: Constants.onboardingIdentifier)
            return false
        }
    }
    
    func showMainFlow() {
        let homeCoordinator = ADHomeCoordinator(
            parentCoordinator: self,
            navigationController: navigationController
        )
        
        addChildCoordinator(homeCoordinator)
        homeCoordinator.start()
    }
    
    func showOnboardingFlow() {
        let onboardingCoordinator = ADOnboardingCoordinator(
            parentCoordinator: self,
            navigationController: navigationController
        )
        
        onboardingCoordinator.onFinish = { [weak self, weak onboardingCoordinator] in
            guard let self, let onboardingCoordinator else { return }
            self.removeChildCoordinator(onboardingCoordinator)
            self.showMainFlow()
        }
        
        addChildCoordinator(onboardingCoordinator)
        onboardingCoordinator.start()
    }
    
    enum Constants {
        static let onboardingIdentifier = "onboardingHasCompleted"
    }
}
