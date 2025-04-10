//
//  OnboardingViewCell.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 4/7/25.
//

import UIKit

import SnapKit

final class OnboardingViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let reuseIdentifier = "OnboardingViewCell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
