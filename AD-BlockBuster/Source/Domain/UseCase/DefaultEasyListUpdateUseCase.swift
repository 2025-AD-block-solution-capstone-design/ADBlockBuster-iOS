//
//  DefaultEasyListUpdateUseCase.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 5/15/25.
//

import Foundation

struct DefaultEasyListUpdateUseCase: EasyListUpdateUseCase {
    let repository: EasyListRepository
    let storage: AppGroupStorage
    
    init(
        repository: EasyListRepository,
        storage: AppGroupStorage
    ) {
        self.repository = repository
        self.storage = storage
    }
    
    func execute() async throws {
        let configs: [(RuleSetType, String, String)] = [
            (.easylist, Constants.easyListNetworkRuleFileName, Constants.easyListCosmeticRuleFileName),
            (.easyprivacy, Constants.easyPrivacyNetworkRuleFileName, Constants.easyPrivacyCosmeticRuleFileName)
        ]

        try await configs.asyncForEach { (type, networkFile, cosmeticFile) in
            let (networkRule, cosmeticRule) = try await repository.fetch(type)
            try storage.save(networkRule, to: networkFile)
            try storage.save(cosmeticRule, to: cosmeticFile)
        }
    }
}

private extension DefaultEasyListUpdateUseCase {
    enum Constants {
        static let easyListNetworkRuleFileName: String = "easylist-network.json"
        static let easyListCosmeticRuleFileName: String = "easylist-cosmetic.json"
        static let easyPrivacyNetworkRuleFileName: String = "easyprivacy-network.json"
        static let easyPrivacyCosmeticRuleFileName: String = "easyprivacy-cosmetic.json"
    }
}

fileprivate extension Array {
    func asyncForEach(_ operation: (Element) async throws -> Void) async throws {
        for element in self {
            try await operation(element)
        }
    }
}
