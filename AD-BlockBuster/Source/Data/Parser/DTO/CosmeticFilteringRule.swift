//
//  CosmeticFilteringRule.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 4/30/25.
//

import Foundation

struct CosmeticFilteringRule: Codable {
    var selector: String
    var action: CosmeticActionType
    var domains: [String]?
}

extension CosmeticFilteringRule {
    static let regex = try! NSRegularExpression(
        pattern: #"^([^:]+)(?::style\((.+?)\))?$"#
    )
    func toEntity() -> ADBlockRule {
        ADBlockRule(
            type: .cosmetic,
            selector: selector,
            cosmeticAction: action,
            cosmeticDomains: domains,
            trigger: nil,
            networkAction: nil
        )
    }
}
