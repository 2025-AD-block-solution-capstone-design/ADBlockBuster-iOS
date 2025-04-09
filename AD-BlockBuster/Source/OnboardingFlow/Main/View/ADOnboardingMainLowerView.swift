//
//  ADOnboardingMainLowerView.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 4/3/25.
//

import UIKit

import SnapKit

protocol ADOnboardingMainLowerViewDelegate: AnyObject {
    func ADOnboardingMainLowerViewDidTapNextButton(_ view: ADOnboardingMainLowerView)
}

final class ADOnboardingMainLowerView: BaseView {
    // MARK: - Properties
    weak var delegate: ADOnboardingMainLowerViewDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(
            size: LayoutContants.titleLabelFontSize,
            weight: .semibold
        )
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(
            size: LayoutContants.contentLabelFontSize,
            weight: .regular
        )
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let nextButton = BaseButton(radius: LayoutContants.nextButtonRadius)
    
    // MARK: - Methods
    override func setupView() {
        [titleLabel, descriptionLabel, nextButton].forEach(addSubview)
    }
    
    override func configure() {
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    override func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
                .inset(LayoutContants.titleLabelTopInset)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
                .offset(LayoutContants.descriptionLabelTopOffset)
            $0.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
                .inset(LayoutContants.horizontalInset)
            $0.bottom.equalToSuperview()
                .inset(LayoutContants.nextButtonBottomInset)
            $0.height.equalTo(LayoutContants.nextButtonHeight)
        }
    }
    
    func setTitles(from data: OnboardingPage) {
        titleLabel.text = data.title
        descriptionLabel.text = data.description
        nextButton.setTitle(data.buttonTitle, for: .normal)
    }
}

// MARK: - Private Methods
private extension ADOnboardingMainLowerView {
    @objc
    func nextButtonTapped() {
        delegate?.ADOnboardingMainLowerViewDidTapNextButton(self)
    }
}

// MARK: - Constants
private extension ADOnboardingMainLowerView {
    struct OnboardingDescription {
        let title: String
        let description: String
        let buttonDescription: String
    }
    
    enum LayoutContants {
        static let titleLabelTopInset: CGFloat = 20
        static let titleLabelFontSize: CGFloat = 20
        static let descriptionLabelTopOffset: CGFloat = 32
        static let contentLabelFontSize: CGFloat = 16
        static let nextButtonRadius: CGFloat = 12
        static let nextButtonBottomInset: CGFloat = 28
        static let horizontalInset: CGFloat = 16
        static let nextButtonHeight: CGFloat = 56
    }
}
