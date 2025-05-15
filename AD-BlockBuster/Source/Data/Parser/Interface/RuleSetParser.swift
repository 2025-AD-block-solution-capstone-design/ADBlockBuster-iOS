//
//  RuleSetParser.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 5/7/25.
//

import Foundation

protocol RuleSetParser {
    associatedtype rule
    static var shared: Self { get }
    func parse(from data: Data) throws -> [rule]
}
