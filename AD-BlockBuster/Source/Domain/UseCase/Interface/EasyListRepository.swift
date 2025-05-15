//
//  EasyListRepository.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 5/15/25.
//

import Foundation

protocol EasyListRepository {
    func fetch(_ type: RuleSetType) async throws -> (
        networkRule: [NetworkFilteringRule],
        cosmeticRule: [CosmeticFilteringRule]
    )
}
