//
//  SafariExtensionStatusChecker.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 5/16/25.
//

import Foundation
import os

struct SafariExtensionStatusChecker: ExtensionStatusProviding {
    private let storage: AppGroupStorage
    
    init(storage: AppGroupStorage) {
        self.storage = storage
    }
    
    func isEnabled(
        withIdentifier identifier: String,
        completion: @escaping (Bool) -> Void
    ) {
        do {
            let loaded = try storage.load(ExtensionStatus.self, from: identifier.appending("status.json"))
            let isEnabled = abs(Date().timeIntervalSince(loaded.updatedAt)) <= 600
            completion(isEnabled)
        } catch {
            os_log("상태 파일 로드 실패")
        }
    }
}
