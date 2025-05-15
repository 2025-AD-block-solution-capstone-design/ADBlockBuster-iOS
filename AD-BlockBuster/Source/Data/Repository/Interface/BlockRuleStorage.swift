//
//  BlockRuleStorage.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 5/15/25.
//

protocol BlockRuleStorage {
    func save<T: Encodable>(_ value: T, to fileName: String) throws
    func load<T: Decodable>(_ type: T.Type, from fileName: String) throws -> T
}
