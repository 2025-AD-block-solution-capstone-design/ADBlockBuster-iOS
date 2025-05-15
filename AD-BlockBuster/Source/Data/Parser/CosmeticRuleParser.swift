//
//  CosmeticRuleParser.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 5/14/25.
//

import Foundation

final class CosmeticRuleParser: RuleSetParser {
    static let shared = CosmeticRuleParser()
    
    private init() {}
    
    func parse(from data: Data) -> [CosmeticFilteringRule] {
        guard let text = String(data: data, encoding: .utf8) else { return [] }
        return text.lazy
            .split(separator: "\n")
            .map(String.init)
            .compactMap(parseLine)
    }
}

private extension CosmeticRuleParser {
    func parseLine(_ line: String) -> CosmeticFilteringRule? {
        let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty,
              !trimmed.hasPrefix("!"),
              !trimmed.contains("#?#"),
              !trimmed.contains("#@#"),
              !trimmed.hasPrefix("@@") else {
            return nil
        }
        
        return parseBasicRule(trimmed)
    }
    
    func parseBasicRule(_ line: String) -> CosmeticFilteringRule? {
        guard let match = CosmeticFilteringRule.regex.firstMatch(
            in: line,
            range: line.nsRange
        ) else { return nil }

        let selector = line.capture(matching: match, at: 1)
        let style = line.capture(matching: match, at: 2)

        guard let selector else { return nil }
        let action: CosmeticActionType = style.map { .style($0) } ?? .hide

        return CosmeticFilteringRule(
            selector: selector,
            action: action
        )
    }
}

fileprivate extension String {
    var nsRange: NSRange {
        NSRange(startIndex..<endIndex, in: self)
    }

    func capture(matching match: NSTextCheckingResult, at index: Int) -> String? {
        guard let range = Range(match.range(at: index), in: self) else { return nil }
        return String(self[range])
    }
}
