//
//  ADBlockRuleParser.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 5/14/25.
//

import Foundation

final class ADBlockRuleParser: RuleSetParser {
    static let shared = ADBlockRuleParser()
    
    private init() {}
    
    func parse(from data: Data) -> [ADBlockRule] {
        let cosmetic = CosmeticRuleParser.shared.parse(from: data)
            .map { $0.toEntity() }
        let network = ContentBlockerParser.shared.parse(from: data)
            .map { $0.toEntity() }

        return cosmetic + network
    }
}
