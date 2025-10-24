//
//  ExtensionStatusProviding.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 5/16/25.
//

protocol ExtensionStatusProviding {
    func isEnabled(
        withIdentifier identifier: String,
        completion: @escaping (Bool) -> Void
    )
}
