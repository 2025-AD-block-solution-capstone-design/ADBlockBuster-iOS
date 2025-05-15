//
//  NetworkFilteringRule+init?.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 5/15/25.
//

extension NetworkFilteringRule {
    init?(from rule: ADBlockRule) {
        guard rule.type == .network,
              let trigger = rule.trigger,
              let action = rule.networkAction else {
            return nil
        }

        self.trigger = trigger
        self.action = action
    }
}
