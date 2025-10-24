//
//  AppCoordinator.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 4/2/25.
//

import UIKit

final class AppCoordinator: Coordinator {
    // MARK: - Properties
    weak var parentCoordinator: Coordinator?
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
        return UserDefaults.standard.bool(forKey: Constants.onboardingIdentifier)
    }
    
    func showMainFlow() {
        Task {
            do {
                let storage = try BlockRuleStorage()
                let fetcher = EasyListFetcher()
                let repository = DefaultEasyListRepository(fetcher: fetcher)
                let useCase = DefaultEasyListUpdateUseCase(
                    repository: repository,
                    storage: storage
                )

                print("[AppCoordinator] 🔄 Updating EasyList rules...")
                try await useCase.execute()
                print("[AppCoordinator] ✅ EasyList rules updated successfully!")
            } catch {
                print("[AppCoordinator] ❌ Failed to update EasyList: \(error)")
            }
        }

        let homeCoordinator = ADHomeCoordinator(
            parentCoordinator: self,
            navigationController: navigationController
        )

        addChildCoordinator(homeCoordinator)
        homeCoordinator.start()
    }
    
    func showOnboardingFlow() {
        let suiteKeyStore = UserDefaults(suiteName: "group.xyz.jiyong.AD-BlockBuster")
        suiteKeyStore?.set(true, forKey: "user_defaults_suite_enabled")
        
        let onboardingCoordinator = ADOnboardingCoordinator(
            parentCoordinator: self,
            navigationController: navigationController
        )
        
        onboardingCoordinator.onFinish = { [weak self, weak onboardingCoordinator] in
            guard let self, let onboardingCoordinator else { return }
            self.removeChildCoordinator(onboardingCoordinator)
            self.showMainFlow()
            self.onboardingFinished()
        }
        
        addChildCoordinator(onboardingCoordinator)
        onboardingCoordinator.start()
    }
    
    func onboardingFinished() {
        UserDefaults.standard.set(true, forKey: Constants.onboardingIdentifier)
    }
    
    enum Constants {
        static let onboardingIdentifier = "onboardingHasCompleted"
    }
}
