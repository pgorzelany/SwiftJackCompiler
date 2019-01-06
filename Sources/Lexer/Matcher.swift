//
//  File.swift
//  Lexer
//
//  Created by Piotr Gorzelany on 06/01/2019.
//

import Common
import Foundation

extension String {
    func tokenMatchRange(regex: String) -> Range<String.Index>? {
        guard let matchRange = self.range(of: regex, options: .regularExpression), matchRange.lowerBound != matchRange.upperBound, self.starts(with: self[matchRange]) else {
            return nil
        }

        return matchRange
    }
}

protocol Matcher {
    func match(input: String) -> (token: Token, remaining: String)?
}

class WhitespaceMatcher: Matcher {
    func match(input: String) -> (token: Token, remaining: String)? {
        let regex = "\\s+"
        guard let matchRange = input.tokenMatchRange(regex: regex) else {
            return nil
        }

        return (Token.whitespace, String(input[matchRange.upperBound...]))
    }
}

class StringLiteralMatcher: Matcher {
    func match(input: String) -> (token: Token, remaining: String)? {
        let regex = "[a-z]+"
        guard let matchRange = input.tokenMatchRange(regex: regex) else {
            return nil
        }

        return (Token.stringLiteral(String(input[matchRange])), String(input[matchRange.upperBound...]))
    }
}
