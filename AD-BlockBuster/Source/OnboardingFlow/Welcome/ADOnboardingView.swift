//
//  ADOnboardingView.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 4/1/25.
//

import UIKit

import SnapKit

protocol ADOnboardingViewDelegate: AnyObject {
    func ADOnboardingViewDidTapNextButton(_ view: ADOnboardingView)
}

final class ADOnboardingView: BaseView {
    weak var delegate: ADOnboardingViewDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.pretendard(
            size: LayoutContants.titleFontSize,
            weight: .ultraLight
        )
        label.numberOfLines = .zero
        label.textAlignment = .left
        label.textColor = .neutral
        return label
    }()
    
    private let nextButton = BaseButton(
        title: Constants.nextButton,
        radius: LayoutContants.buttonRadius
    )
    
    override func setupView() {
        [titleLabel, nextButton].forEach(addSubview)
    }
    
    override func configure() {
        titleLabel.attributedText = makeAttributedString()
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    override func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
                .inset(LayoutContants.horizontalInset)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
                .inset(LayoutContants.horizontalInset)
            $0.height.equalTo(LayoutContants.buttonHeight)
            $0.bottom.equalToSuperview()
                .inset(LayoutContants.nextButtonBottomInset)
        }
    }
}

private extension ADOnboardingView {
    @objc
    func nextButtonTapped() {
        delegate?.ADOnboardingViewDidTapNextButton(self)
    }
    
    func makeAttributedString() -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: Constants.welcomeMessage)
        guard let range = Constants.welcomeMessage.range(of: Constants.title) else {
            return attributedString
        }
        
        let nsRange = NSRange(range, in: Constants.welcomeMessage)
        attributedString.addAttribute(
            .font,
            value: UIFont.pretendard(
                size: LayoutContants.titleFontSize,
                weight: .medium
            ),
            range: nsRange
        )
        
        return attributedString
    }
}

private extension ADOnboardingView {
    enum LayoutContants {
        static let titleFontSize: CGFloat = 40
        static let buttonFontSize: CGFloat = 20
        static let buttonRadius: CGFloat = 12
        static let buttonHeight: CGFloat = 56
        static let horizontalInset: CGFloat = 16
        static let nextButtonBottomInset: CGFloat = 28
    }
    
    enum Constants {
        static let title: String = "AD-BlockBuster"
        static let welcomeMessage: String = """
        AD-BlockBuster로
        불필요한 광고를
        차단하세요
        """
        static let nextButton: String = "시작하기"
    }
}
