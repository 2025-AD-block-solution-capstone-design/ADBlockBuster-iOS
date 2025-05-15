//
//  EasyListFetching.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 5/15/25.
//

import Foundation

protocol EasyListFetching {
    func fetch(from endpoint: EasyListEndpoint) async throws -> Data
}
