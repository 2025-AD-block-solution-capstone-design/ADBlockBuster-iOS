//
//  ADHomeCoordinator.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 4/2/25.
//

import UIKit

final class ADHomeCoordinator: Coordinator {
    // MARK: - Properties
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
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
        let homeViewController = ADHomeViewController()
        homeViewController.coordinator = self
        navigationController.setViewControllers([homeViewController], animated: true)
    }
}
