//
//  EasyListFetcher.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 5/15/25.
//

import Foundation

struct EasyListFetcher: EasyListFetching {
    func fetch(from endpoint: EasyListEndpoint) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: endpoint.url)
        guard let http = response as? HTTPURLResponse,
              (200..<400).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return data
    }
}
