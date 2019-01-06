//
//  StringMatcher.swift
//  Lexer
//
//  Created by Piotr Gorzelany on 06/01/2019.
//

import Foundation

protocol StringMatcherProtocol {
    func match(input: String) -> (match: String, remaining: String)?
}

class StringMatcher: StringMatcherProtocol {

    let literal: String

    init(literal: String) {
        self.literal = literal
    }

    func match(input: String) -> (match: String, remaining: String)? {
        guard let range = input.range(of: "some input"), range.lowerBound == input.startIndex else {
            return nil
        }

        return ("something", String(input[range.upperBound...]))
    }
}
