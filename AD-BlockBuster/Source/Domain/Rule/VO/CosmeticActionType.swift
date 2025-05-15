//
//  CosmeticActionType.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 5/14/25.
//

enum CosmeticActionType: Codable {
    case hide
    case style(String)
    
    enum CodingKeys: String, CodingKey {
        case type
        case value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        
        switch type {
        case "hide":
            self = .hide
        case "style":
            let value = try container.decode(String.self, forKey: .value)
            self = .style(value)
        default:
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "타입 에러: \(type)")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .hide:
            try container.encode("hide", forKey: .type)
        case .style(let style):
            try container.encode("style", forKey: .type)
            try container.encode(style, forKey: .value)
        }
    }
}
