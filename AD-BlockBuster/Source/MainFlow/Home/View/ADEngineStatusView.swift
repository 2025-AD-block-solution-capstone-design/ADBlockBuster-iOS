//
//  ADEngineStatusView.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 4/9/25.
//

import UIKit
import SnapKit

final class ADEngineStatusView: BaseView {
    // MARK: - Properties
    private var sideLength: CGFloat = .zero {
        didSet {
            guard oldValue != sideLength else { return }
            setNeedsUpdateConstraints()
        }
    }
    
    private var status: ADEngineStatus = .undefined
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.textAlignment = .left
        label.textColor = .white
        label.font = .pretendard(
            size: LayoutContants.titleFontSize,
            weight: .semibold
        )
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.textAlignment = .left
        label.textColor = .white
        label.font = .pretendard(
            size: LayoutContants.descriptionFontSize,
            weight: .regular
        )
        return label
    }()
    
    private let statusIcon: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    // MARK: - Initialize
    init(status: ADEngineStatus = .undefined) {
        self.status = status
        super.init(frame: .zero)
        applyStatus()
    }
    
    // MARK: - Life Cycle
    override func updateConstraints() {
        super.updateConstraints()
        
        snp.updateConstraints {
            $0.height.equalTo(sideLength)
        }
    }
    
    // MARK: - Methods
    override func setupView() {
        [titleLabel, descriptionLabel, statusIcon].forEach(addSubview)
    }
    
    override func configure() {
        layer.cornerRadius = LayoutContants.cornerRadius
        
        titleLabel.text = "NullEngine"
        descriptionLabel.text = """
        ViewModel 구현 전
        임시로 넣는 설명
        한 줄 더 쓰기
        """
    }
    
    override func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
                .inset(LayoutContants.titleInset)
        }
        
        statusIcon.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
                .offset(LayoutContants.iconTopOffset)
            $0.leading.equalToSuperview()
                .inset(LayoutContants.iconLeadingInset)
            $0.width.height.equalTo(LayoutContants.iconSize)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
                .offset(LayoutContants.descriptionTopOffset)
            $0.leading.equalTo(statusIcon.snp.trailing)
                .offset(LayoutContants.descriptionLeadaingOffset)
            $0.trailing.equalToSuperview()
                .inset(LayoutContants.titleInset)
        }
    }
    
    func setStatus(_ status: ADEngineStatus) {
        self.status = status
        applyStatus()
    }
    
    func setText(
        title titleText: String,
        description descriptionText: String
    ) {
        titleLabel.text = titleText
        descriptionLabel.text = descriptionText
    }
    
    func setText(to descriptionText: String) {
        descriptionLabel.text = descriptionText
    }
    
    func setSideLength(to sideLength: CGFloat) {
        self.sideLength = sideLength
    }
}

// MARK: - Private Methods
private extension ADEngineStatusView {
    func applyStatus() {
        switch status {
        case .running:
            statusIcon.image = UIImage(named: "icons/success")!
            backgroundColor = UIColor(hex: "#4187F5")
        case .stopped:
            statusIcon.image = UIImage(named: "icons/warning")!
            backgroundColor = .failure
        case .undefined:
            statusIcon.image = UIImage(named: "icons/lock")!
                .withRenderingMode(.alwaysTemplate)
            statusIcon.tintColor = .black
            backgroundColor = .gray
        }
    }
}

// MARK: - Constants
private extension ADEngineStatusView {
    enum LayoutContants {
        static let cornerRadius: CGFloat = 12
        static let titleInset: CGFloat = 16
        static let titleFontSize: CGFloat = 20
        static let descriptionFontSize: CGFloat = 14
        static let descriptionLeadaingOffset: CGFloat = 10
        static let descriptionTopOffset: CGFloat = 12
        static let iconTopOffset: CGFloat = 17
        static let iconLeadingInset: CGFloat = 16
        static let iconSize: CGFloat = 14
    }
}
