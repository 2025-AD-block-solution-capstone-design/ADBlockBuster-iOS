//
//  ADOnboardingMainViewController.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 4/2/25.
//

import Combine
import UIKit

final class ADOnboardingMainViewController: BaseViewController<ADOnboardingMainView> {
    // MARK: - Properties
    weak var coordinator: ADOnboardingMainCoordinator?
    
    let viewModel = ADOnboardingMainViewModel()
    var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.delegate = self
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func bindState() {
        viewModel.$state
            .map { OnboardingPage(title: $0.title, description: $0.description, buttonTitle: $0.buttonTitle) }
            .removeDuplicates()
            .sink { [weak self] page in
                self?.contentView.setLowerView(from: page)
            }
            .store(in: &cancellables)
    }
}

extension ADOnboardingMainViewController: ADOnboardingMainViewDelegate {
    func ADOnboardingMainViewDidTapNextButton(_ view: ADOnboardingMainView) {
        coordinator?.popAndFinish()
    }
    
    func ADOnboardingMainViewDidChangePage(
        _ view: ADOnboardingMainView,
        currentPage: Int
    ) {
        viewModel.action(.pageChanged(currentPage))
    }
}
