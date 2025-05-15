//
//  NetworkFilteringTrigger.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 5/15/25.
//

struct NetworkFilteringTrigger: Codable {
    var urlFilter: String
    var resourceType: [String]?
    
    enum CodingKeys: String, CodingKey {
        case urlFilter = "url-filter"
        case resourceType = "resource-type"
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(urlFilter, forKey: .urlFilter)
        if let resourceType = resourceType, !resourceType.isEmpty {
            try container.encode(resourceType, forKey: .resourceType)
        }
    }
}
