//
//  ADHomeViewController.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 4/1/25.
//

import UIKit

final class ADHomeViewController: BaseViewController<ADHomeView> {
    weak var coordinator: ADHomeCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

private extension ADHomeViewController {
    @objc
    func rightBarButtonTapped() {
        
    }
    
    func setupNavigationBar() {
        let leftBarButtonImage = UIImage(named: LayoutConstants.leftImageName)
        let rightBarButtonImage = UIImage(named: LayoutConstants.rightImageName)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: leftBarButtonImage,
            style: .plain,
            target: nil,
            action: nil
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: rightBarButtonImage,
            style: .plain,
            target: self,
            action: #selector(rightBarButtonTapped)
        )
    }
}

private extension ADHomeViewController {
    enum LayoutConstants {
        static let leftImageName: String = "icons/tornado"
        static let rightImageName: String = "icons/setting"
    }
}
