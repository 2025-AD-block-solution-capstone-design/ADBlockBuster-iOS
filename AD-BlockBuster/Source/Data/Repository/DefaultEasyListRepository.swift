//
//  DefaultEasyListRepository.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 5/15/25.
//

import Foundation

struct DefaultEasyListRepository: EasyListRepository {
    private let fetcher: EasyListFetching

    init(fetcher: EasyListFetching) {
        self.fetcher = fetcher
    }
    
    func fetch(_ type: RuleSetType) async throws -> (
        networkRule: [NetworkFilteringRule],
        cosmeticRule: [CosmeticFilteringRule]
    ) {
        let endpoint: EasyListEndpoint
        
        switch type {
        case .easylist: endpoint = .easylist
        case .easyprivacy: endpoint = .easyprivacy
        }
        
        return ADBlockRuleParser.shared
            .parse(from: try await fetcher.fetch(from: endpoint))
            .classify()
    }
}
