//
//  SafariWebExtensionHandler.swift
//  CSSBlockEngine
//
//  Created by 정지용 on 4/2/25.
//

import SafariServices
import os.log
import Foundation

let SFExtensionMessageKey = "message"

// MARK: - Data Models
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
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Invalid type: \(type)")
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

struct CosmeticFilteringRule: Codable {
    var selector: String
    var action: CosmeticActionType
    var domains: [String]?
}

enum SafariExtensionRequestEnum: String {
    case requestEnabledStatus = "request:enabled_status"
    case requestCosmeticRules = "request:cosmetic_rules"
}

enum SafariExtensionDeliveryEnum: String {
    case deliveryEnabledStatus = "delivery:enabled_status"
    case deliveryCosmeticRules = "delivery:cosmetic_rules"
}

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {

    private let suiteKeyStore = UserDefaults(suiteName: "group.xyz.jiyong.AD-BlockBuster")
        
    func beginRequest(with context: NSExtensionContext) {
        guard let item = context.inputItems[0] as? NSExtensionItem else {
            return
        }
        let message = item.userInfo?[SFExtensionMessageKey]
        let messageDictionary = message as? [String: String]
        let innerMessage = messageDictionary?[SFExtensionMessageKey] as? String
        
        if let msg =  message as? CVarArg {
            os_log(.default, "SafariWebExtensionHandler XXXX Received message from browser.runtime.sendNativeMessage: %@", msg)
        }
        
        let response = NSExtensionItem()
        
        if let msg = innerMessage,
           let request = SafariExtensionRequestEnum(rawValue: msg) {
            switch request {
            case .requestEnabledStatus:
                let keyName = "user_defaults_suite_enabled"
                let enabledFromDefaults = suiteKeyStore?.bool(forKey: keyName)
                response.userInfo = [
                    SFExtensionMessageKey : [
                        SafariExtensionDeliveryEnum.deliveryEnabledStatus.rawValue: enabledFromDefaults
                    ]
                ]

            case .requestCosmeticRules:
                do {
                    guard let containerURL = FileManager.default.containerURL(
                        forSecurityApplicationGroupIdentifier: "group.xyz.jiyong.AD-BlockBuster"
                    ) else {
                        throw NSError(domain: "AppGroupStorage", code: 1, userInfo: nil)
                    }

                    var allRules: [CosmeticFilteringRule] = []

                    let ruleFiles = [
                        "easylist-cosmetic.json",
                        "easyprivacy-cosmetic.json"
                    ]

                    for fileName in ruleFiles {
                        let fileURL = containerURL.appendingPathComponent(fileName)
                        if FileManager.default.fileExists(atPath: fileURL.path) {
                            let data = try Data(contentsOf: fileURL)
                            let rules = try JSONDecoder().decode([CosmeticFilteringRule].self, from: data)
                            allRules.append(contentsOf: rules)
                            os_log(.default, "Loaded %d rules from %@", rules.count, fileName)
                        }
                    }

                    let jsRules = allRules.map { rule -> [String: Any] in
                        var jsRule: [String: Any] = [
                            "selector": rule.selector
                        ]

                        if let domains = rule.domains {
                            jsRule["domains"] = domains
                        } else {
                            jsRule["domains"] = NSNull()
                        }

                        switch rule.action {
                        case .hide:
                            jsRule["action"] = ["type": "hide"]
                        case .style(let css):
                            jsRule["action"] = ["type": "style", "value": css]
                        }

                        return jsRule
                    }

                    response.userInfo = [
                        SFExtensionMessageKey: [
                            SafariExtensionDeliveryEnum.deliveryCosmeticRules.rawValue: jsRules
                        ]
                    ]

                    os_log(.default, "Delivered %d cosmetic rules to extension", jsRules.count)

                } catch {
                    os_log(.error, "Failed to load cosmetic rules: %@", error.localizedDescription)
                    response.userInfo = [
                        SFExtensionMessageKey: [
                            SafariExtensionDeliveryEnum.deliveryCosmeticRules.rawValue: []
                        ]
                    ]
                }
            }
        }
        os_log(.default, "SafariWebExtensionHandler XXXX response: \([response])")
        context.completeRequest(returningItems: [response], completionHandler: nil)
    }
}
