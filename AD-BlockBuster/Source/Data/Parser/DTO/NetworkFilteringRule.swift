//
//  NetworkFilteringRule.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 4/29/25.
//

struct NetworkFilteringRule: Codable {
    var trigger: NetworkFilteringTrigger
    var action: NetworkFilteringAction
}
