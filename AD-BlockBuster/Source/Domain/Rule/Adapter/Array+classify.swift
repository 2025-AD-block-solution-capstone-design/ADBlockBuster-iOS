//
//  Array+classify.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 5/15/25.
//

extension Array where Element == ADBlockRule {
    func classify() -> ([NetworkFilteringRule], [CosmeticFilteringRule]) {
        return self.reduce(into: ([], [])) { result, rule in
            switch rule.type {
            case .network:
                if let network = NetworkFilteringRule(from: rule) {
                    result.0.append(network)
                }
            case .cosmetic:
                if let cosmetic = CosmeticFilteringRule(from: rule) {
                    result.1.append(cosmetic)
                }
            }
        }
    }
}
