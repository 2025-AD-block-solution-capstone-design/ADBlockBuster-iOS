//
//  UIFont+.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 4/2/25.
//

import UIKit

extension UIFont {
    static func pretendard(
        size fontSize: CGFloat,
        weight: UIFont.Weight
    ) -> UIFont {
        let fontName = "Pretendard-\(makeFontDescriptor(weight: weight))"
        return UIFont(name: fontName, size: fontSize) ??
            .systemFont(ofSize: fontSize, weight: .semibold)
    }
    
    private static func makeFontDescriptor(weight: UIFont.Weight) -> String {
        return {
            switch weight {
            case .black:
                return "Black"
            case .bold:
                return "Bold"
            case .heavy:
                return "ExtraBold"
            case .light:
                return "Light"
            case .medium:
                return "Medium"
            case .semibold:
                return "Semibold"
            case .thin:
                return "Thin"
            case .ultraLight:
                return "ExtraLight"
            default:
                return "Regular"
            }
        }()
    }
}
