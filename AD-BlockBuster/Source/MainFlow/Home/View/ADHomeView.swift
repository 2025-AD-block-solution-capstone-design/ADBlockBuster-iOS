//
//  ADHomeView.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 4/2/25.
//

import UIKit
import SnapKit

final class ADHomeView: BaseView {
    // MARK: - Properties
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = .pretendard(
            size: LayoutContants.titleFontSize,
            weight: .semibold
        )
        label.textColor = .neutral
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = .pretendard(
            size: LayoutContants.descriptionFontSize,
            weight: .regular
        )
        label.textColor = .neutral
        return label
    }()
    
    private let statusView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = LayoutContants.stackViewSpacing
        stackView.layoutMargins = UIEdgeInsets(
            top: 0,
            left: LayoutContants.horizontalInset,
            bottom: 0,
            right: LayoutContants.horizontalInset
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    // MARK: - Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = bounds.width
        let widthWithConstraint = width - LayoutContants.horizontalInset * 2
        let numberOfItemsInRow = 2
        let totalSpacing = LayoutContants.stackViewSpacing * CGFloat(numberOfItemsInRow - 1)
        let itemWidth = (widthWithConstraint - totalSpacing) / CGFloat(numberOfItemsInRow)
        
        statusView.arrangedSubviews
            .compactMap { $0 as? UIStackView }
            .flatMap(\.arrangedSubviews)
            .compactMap { $0 as? ADEngineStatusView }
            .forEach { $0.setSideLength(to: itemWidth) }
    }
    
    // MARK: - Methods
    override func setupView() {
        addSubview(scrollView)
        [titleLabel, descriptionLabel, statusView].forEach(scrollView.addSubview)
    }
    
    override func configure() {
        repeatElement((), count: 3).forEach { _ in
            statusView.addArrangedSubview(createStatusViewStack())
        }
        
        titleLabel.text = "임시로 채워넣을 문자열"
        descriptionLabel.text = """
        임시로 두줄 이상의 문자열을
        아무렇게나 넣어봐요 !
        """
    }
    
    override func setupLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
                .inset(LayoutContants.labelTopSpacing)
            $0.leading.equalToSuperview()
                .inset(LayoutContants.horizontalInset)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
                .offset(LayoutContants.labelTopSpacing)
            $0.leading.equalToSuperview()
                .inset(LayoutContants.horizontalInset)
        }
        
        statusView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom)
                .offset(LayoutContants.stackViewTopOffset)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: - Private Methods
private extension ADHomeView {
    func createStatusViewStack() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = LayoutContants.stackViewSpacing
        [ADEngineStatusView(), ADEngineStatusView()].forEach(stackView.addArrangedSubview)
        return stackView
    }
}

// MARK: - Constants
private extension ADHomeView {
    enum Constants {
        
    }
    
    enum LayoutContants {
        static let titleFontSize: CGFloat = 24
        static let descriptionFontSize: CGFloat = 20
        static let stackViewSpacing: CGFloat = 18
        static let labelTopSpacing: CGFloat = 20
        static let horizontalInset: CGFloat = 16
        static let stackViewTopOffset: CGFloat = 40
    }
}
