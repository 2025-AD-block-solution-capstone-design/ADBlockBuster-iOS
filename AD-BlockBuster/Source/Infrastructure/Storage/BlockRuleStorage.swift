//
//  BlockRuleStorage.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 5/15/25.
//

import Foundation

struct BlockRuleStorage: AppGroupStorage {
    private let containerURL: URL
    
    init() throws {
        guard let url = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: Self.identifier
        ) else {
            // TODO: 런타임 크래시 제거
            throw NSError(domain: "AppGroupStorage", code: 1, userInfo: nil)
        }
        self.containerURL = url
    }
    
    func save<T>(_ value: T, to fileName: String) throws where T : Encodable {
        let fileURL = containerURL.appendingPathComponent(fileName)
        let data = try JSONEncoder().encode(value)
        try data.write(to: fileURL, options: .atomic)
    }
    
    func load<T: Decodable>(_ type: T.Type, from fileName: String) throws -> T {
        let fileURL = containerURL.appendingPathComponent(fileName)
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
