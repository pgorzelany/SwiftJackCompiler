//
//  File.swift
//  Lexer
//
//  Created by Piotr Gorzelany on 06/01/2019.
//

import Common
import Foundation

protocol Matcher {
    func match(input: String) -> (token: Token, remaining: String)?
}

class WhitespaceMatcher: Matcher {
    func match(input: String) -> (token: Token, remaining: String)? {
        let regex = "\\s*"
        guard let matchRange = input.range(of: regex, options: .regularExpression), matchRange.lowerBound != matchRange.upperBound, input.starts(with: input[matchRange]) else {
            return nil
        }

        return (Token.whitespace, String(input[matchRange.upperBound...]))
    }
}
