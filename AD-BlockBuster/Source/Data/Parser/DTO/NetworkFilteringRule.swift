//
//  NetworkFilteringRule.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 4/29/25.
//

struct NetworkFilteringRule: Codable {
    var trigger: NetworkFilteringTrigger
    var action: NetworkFilteringAction
}

extension NetworkFilteringRule {
    func toEntity() -> ADBlockRule {
        ADBlockRule(
            type: .network,
            selector: nil,
            cosmeticAction: nil,
            trigger: trigger,
            networkAction: action
        )
    }
}
