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
}

extension CosmeticFilteringRule {
    static let regex = try! NSRegularExpression(
        pattern: #"^(?:(.*?)##)?([^\s:]+)(?::style\((.+?)\))?$"#
    )
}
