//
//  ContentBlockerStatusChecker.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 5/16/25.
//

import SafariServices

struct ContentBlockerStatusChecker: ExtensionStatusProviding {
    func isEnabled(
        withIdentifier identifier: String,
        completion: @escaping (Bool) -> Void
    ) {
        SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: identifier) { state, _ in
            completion(state?.isEnabled ?? false)
        }
    }
}
