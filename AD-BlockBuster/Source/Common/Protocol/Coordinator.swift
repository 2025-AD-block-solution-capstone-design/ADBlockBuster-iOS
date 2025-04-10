//
//  Coordinator.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 4/2/25.
//

import UIKit

protocol Coordinator: AnyObject {
    // MARK: - Properties
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    // MARK: - Methods
    func start()
}

// MARK: - Default Implementation
extension Coordinator {
    func didFinish() {
        finishAllChildCoordinators()
        parentCoordinator?.removeChildCoordinator(self)
        
        if let self = self as? FinishNotifying {
            self.onFinish?()
        }
    }
    
    func popAndFinish(
        animated: Bool = true
    ) {
        guard navigationController.viewControllers.count > 1 else {
            didFinish()
            return
        }
        navigationController.popViewController(animated: animated)
        didFinish()
    }
    
    func addChildCoordinator(
        _ coordinator: Coordinator
    ) {
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
    }
    
    func removeChildCoordinator(
        _ child: Coordinator?
    ) {
        for (idx, coordinator) in childCoordinators.enumerated() where coordinator === child {
            childCoordinators.remove(at: idx)
            break
        }
    }
    
    func finishAllChildCoordinators() {
        for coordinator in childCoordinators {
            coordinator.finishAllChildCoordinators()
        }
        childCoordinators.removeAll()
    }
}
