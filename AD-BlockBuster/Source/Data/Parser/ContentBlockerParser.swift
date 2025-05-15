//
//  ContentBlockerParser.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 4/29/25.
//

import Foundation

final class ContentBlockerParser: RuleSetParser {
    static let shared = ContentBlockerParser()
    
    private init() {}
    
    func parse(from data: Data) -> [NetworkFilteringRule] {
        guard let text = String(data: data, encoding: .utf8) else { return [] }
        return text.lazy
            .split(separator: "\n")
            .map(String.init)
            .compactMap(generateRule)
    }
}

private extension ContentBlockerParser {
    func escapeForRegex(_ domain: String) -> String {
        return domain.replacingOccurrences(of: ".", with: "\\.")
    }
    
    func generateRule(_ content: String) -> NetworkFilteringRule? {
        let line = content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !line.isEmpty,
              !line.hasPrefix("!"),
              !line.hasPrefix("[Adblock") else {
            return nil
        }
        
        for type in [NetworkFilteringRuleType.allow, NetworkFilteringRuleType.block] {
            if let matched = matchRule(from: line, for: type) {
                return matched
            }
        }

        return nil
    }
    
    func matchRule(from content: String, for type: NetworkFilteringRuleType) -> NetworkFilteringRule? {
        guard let match = type.regexExpression.firstMatch(
            in: content,
            range: NSRange(
                content.startIndex...,
                in: content
            )
        ) else { return nil }
        
        let domainRange = Range(match.range(at: 1), in: content)!
        let domain = String(content[domainRange])
        var rule = NetworkFilteringRule(
            trigger: .init(urlFilter: ".*\(escapeForRegex(domain)).*", resourceType: []),
            action: .init(type: type.ruleAction)
        )
        
        if let optionRange = Range(match.range(at: 2), in: content) {
            let option = String(content[optionRange])
            
            if option.contains("domain=") || option.contains("third-party") { return nil }
            if option.contains("image") { rule.trigger.resourceType?.append("image") }
            if option.contains("script") { rule.trigger.resourceType?.append("script") }
        }
        
        return rule
    }
}
