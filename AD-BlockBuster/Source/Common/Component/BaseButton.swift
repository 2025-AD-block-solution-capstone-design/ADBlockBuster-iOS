//
//  BaseButton.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 4/2/25.
//

import UIKit

final class BaseButton: UIButton {
    // MARK: - Properties
    private var title: String
    private var radius: CGFloat
    private var customBackgroundColor: UIColor
    private var customForegroundColor: UIColor
    private var font: UIFont = UIFont.pretendard(
        size: LayoutContants.buttonFontSize,
        weight: .semibold
    )
    
    // MARK: - Initialize
    init(
        title: String = "",
        radius: CGFloat,
        customBackgroundColor: UIColor = .main,
        customForegroundColor: UIColor = .white,
        font: UIFont = UIFont.pretendard(
            size: LayoutContants.buttonFontSize,
            weight: .semibold
        )
    ) {
        self.title = title
        self.radius = radius
        self.customBackgroundColor = customBackgroundColor
        self.customForegroundColor = customForegroundColor
        self.font = font
        super.init(frame: .zero)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods
private extension BaseButton {
    func setupView() {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.baseBackgroundColor = customBackgroundColor
        config.baseForegroundColor = customForegroundColor
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = self.font
            return outgoing
        }
        configuration = config
        layer.cornerRadius = radius
        clipsToBounds = true
    }
}

// MARK: - Constants
private extension BaseButton {
    enum LayoutContants {
        static let buttonFontSize: CGFloat = 20
    }
}
