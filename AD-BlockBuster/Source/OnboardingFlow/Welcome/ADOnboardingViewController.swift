//
//  ADOnboardingViewController.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 4/1/25.
//

import UIKit

final class ADOnboardingViewController: BaseViewController<ADOnboardingView> {
    weak var coordinator: ADOnboardingCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.backgroundColor = .white
        contentView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

extension ADOnboardingViewController: ADOnboardingViewDelegate {
    func ADOnboardingViewDidTapNextButton(_ view: ADOnboardingView) {
    }
}
