//
//  EasyListEndpoint.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 5/15/25.
//

import Foundation

enum EasyListEndpoint {
    case easylist
    case easyprivacy

    var url: URL {
        switch self {
        case .easylist:
            return URL(string: "https://easylist.to/easylist/easylist.txt")!
        case .easyprivacy:
            return URL(string: "https://easylist.to/easylist/easyprivacy.txt")!
        }
    }
}
