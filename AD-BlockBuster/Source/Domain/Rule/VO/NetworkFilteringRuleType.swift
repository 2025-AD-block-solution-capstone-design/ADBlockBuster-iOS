//
//  NetworkFilteringRuleType.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 4/30/25.
//

import Foundation

enum NetworkFilteringRuleType {
    case block
    case allow
    
    var ruleAction: String {
        switch self {
        case .allow: "ignore-previous-rules"
        case .block: "block"
        }
    }
    
    var regexExpression: NSRegularExpression {
        switch self {
        case .allow:
            Self.allowRegex
        case .block:
            Self.blockRegex
        }
    }
}

private extension NetworkFilteringRuleType {
    static let allowRegex = try! NSRegularExpression(
        pattern: #"^@@\|\|([^\^/\$\*]+)\^(\$[^#]+)?"#
    )
    static let blockRegex = try! NSRegularExpression(
        pattern: #"^\|\|([^\^/\$\*]+)\^(\$[^#]+)?"#
    )
}
