//
//  ADOnboardingCoordinator.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 4/2/25.
//

import UIKit

final class ADOnboardingCoordinator: Coordinator, FinishNotifying {
    // MARK: - Properties
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var onFinish: (() -> Void)?
    
    // MARK: - Initialize
    init(
        parentCoordinator: Coordinator?,
        navigationController: UINavigationController
    ) {
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
    }
    
    // MARK: - Methods
    func start() {
        let onboardingViewController = ADOnboardingViewController()
        onboardingViewController.coordinator = self
        navigationController.pushViewController(onboardingViewController, animated: true)
    }
}

// MARK: - Extended Methods
extension ADOnboardingCoordinator {
    func didTapNextButton() {
        let onboardingMainCoordinator = ADOnboardingMainCoordinator(
            parentCoordinator: self,
            navigationController: navigationController
        )
        
        onboardingMainCoordinator.onFinish = { [weak self] in
            self?.popAndFinish()
        }
        
        addChildCoordinator(onboardingMainCoordinator)
        onboardingMainCoordinator.start()
    }
}
