//
//  CosmeticFilteringRule+init?.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 5/15/25.
//

extension CosmeticFilteringRule {
    init?(from rule: ADBlockRule) {
        guard rule.type == .cosmetic,
              let selector = rule.selector,
              let action = rule.cosmeticAction else {
            return nil
        }

        self.selector = selector
        self.action = action
        self.domains = rule.cosmeticDomains
    }
}
