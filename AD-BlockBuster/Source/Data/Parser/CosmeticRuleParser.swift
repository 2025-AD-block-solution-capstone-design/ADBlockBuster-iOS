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

        let totalLines = text.split(separator: "\n").count
        let rules = text.lazy
            .split(separator: "\n")
            .map(String.init)
            .compactMap(parseLine)

        let rulesArray = Array(rules)
        print("[CosmeticRuleParser] Total lines: \(totalLines), Parsed rules: \(rulesArray.count)")

        for (index, rule) in rulesArray.prefix(5).enumerated() {
            print("[CosmeticRuleParser] Rule \(index + 1): domains=\(rule.domains?.joined(separator: ",") ?? "nil"), selector=\(rule.selector)")
        }

        return rulesArray
    }
}

private extension CosmeticRuleParser {
    func parseLine(_ line: String) -> CosmeticFilteringRule? {
        let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty,
              !trimmed.hasPrefix("!") else {
            return nil
        }

        guard !trimmed.contains("#?#"),
              !trimmed.contains("#@#"),
              !trimmed.contains("#$#") else {
            return nil
        }

        guard !trimmed.hasPrefix("@@") else {
            return nil
        }

        guard trimmed.contains("##") else {
            return nil
        }

        let beforeSeparator = trimmed.components(separatedBy: "##").first ?? ""

        guard !beforeSeparator.contains("$"),
              !beforeSeparator.hasPrefix("||"),
              !beforeSeparator.hasPrefix("/") else {
            return nil
        }

        if trimmed.hasPrefix("###") {
            return nil
        }

        return parseBasicRule(trimmed)
    }
    
    func parseBasicRule(_ line: String) -> CosmeticFilteringRule? {
        var separatorRange: Range<String.Index>?
        var isIDSelector = false

        if let range = line.range(of: "###") {
            separatorRange = range
            isIDSelector = true
        } else if let range = line.range(of: "##") {
            separatorRange = range
        }

        guard let range = separatorRange else {
            return nil
        }

        let domainPart = String(line[..<range.lowerBound])
        let domains: [String]? = domainPart.isEmpty ? nil : domainPart.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }

        let selectorPart = String(line[range.upperBound...])
        var trimmedSelector = selectorPart.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedSelector.isEmpty else {
            return nil
        }

        if domains == nil {
            let dangerousSelectors = ["body", "html", "head", "div", "span", "p", "a", "img", "ul", "li", "table", "tr", "td", "th"]
            let selectorLower = trimmedSelector.lowercased()

            if dangerousSelectors.contains(selectorLower) {
                return nil
            }
        }

        if isIDSelector && !trimmedSelector.hasPrefix("#") {
            trimmedSelector = "#" + trimmedSelector
        }

        if trimmedSelector.contains(":style(") {
            let pattern = #"^(.+?):style\((.+?)\)$"#
            guard let regex = try? NSRegularExpression(pattern: pattern),
                  let match = regex.firstMatch(in: trimmedSelector, range: trimmedSelector.nsRange),
                  let selector = trimmedSelector.capture(matching: match, at: 1),
                  let style = trimmedSelector.capture(matching: match, at: 2) else {
                return nil
            }

            return CosmeticFilteringRule(
                selector: selector,
                action: .style(style),
                domains: domains
            )
        } else {
            return CosmeticFilteringRule(
                selector: trimmedSelector,
                action: .hide,
                domains: domains
            )
        }
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
