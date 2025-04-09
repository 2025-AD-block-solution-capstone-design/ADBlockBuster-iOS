//
//  ADOnboardingMainCoordinator.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 4/2/25.
//

import UIKit

final class ADOnboardingMainCoordinator: Coordinator, FinishNotifying {
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var onFinish: (() -> Void)?
    
    init(
        parentCoordinator: Coordinator?,
        navigationController: UINavigationController
    ) {
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
    }
    
    func start() {
        let onboardingMainViewController = ADOnboardingMainViewController()
        onboardingMainViewController.coordinator = self
        navigationController.pushViewController(onboardingMainViewController, animated: true)
    }
}
