//
//  ADBlockRule.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 4/30/25.
//

struct ADBlockRule {
    let type: ADBlockRuleType
    var selector: String?
    var cosmeticAction: CosmeticActionType?
    var cosmeticDomains: [String]?
    var trigger: NetworkFilteringTrigger?
    var networkAction: NetworkFilteringAction?
}
