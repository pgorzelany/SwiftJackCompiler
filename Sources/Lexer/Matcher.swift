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

class IdentifierMatcher: Matcher {
    func match(input: String) -> (token: Token, remaining: String)? {
        let regex = "^([a-z])[a-z0-9]*"
        guard let matchRange = input.tokenMatchRange(regex: regex) else {
            return nil
        }

        return (Token.identifier(String(input[matchRange])), String(input[matchRange.upperBound...]))
    }
}

class KeywordMatcher: Matcher {
    func match(input: String) -> (token: Token, remaining: String)? {
        var regex = "^(\(Keyword.allCases[0])"
        for keyword in Keyword.allCases[1...] {
            regex += "|\(keyword.rawValue)"
        }
        regex += ")"
        guard let matchRange = input.tokenMatchRange(regex: regex), let keyword = Keyword(rawValue: String(input[matchRange])) else {
            return nil
        }

        return (Token.keyword(keyword), String(input[matchRange.upperBound...]))
    }
}

class SymbolMatcher: Matcher {
    func match(input: String) -> (token: Token, remaining: String)? {
        let symbols = ["{", "}" , "(", ")" , "[", "]" , ".", "," , ";", "+" , "-", "*" , "/", "&" , "|", "<" , ">", "=" , "~",]
            .map({NSRegularExpression.escapedPattern(for: $0)})
        var regex = "^(\(symbols[0])"
        for symbol in symbols[1...] {
            regex += "|\(symbol)"
        }
        regex += ")"
        guard let matchRange = input.tokenMatchRange(regex: regex) else {
            return nil
        }

        return (Token.symbol(String(input[matchRange])), String(input[matchRange.upperBound...]))
    }
}

class IntegerConstantMatcher: Matcher {
    func match(input: String) -> (token: Token, remaining: String)? {
        let regex = "^[0-9]"
        guard let matchRange = input.tokenMatchRange(regex: regex), let int = Int16(input[matchRange]), int <= 32767 else {
            return nil
        }

        return (Token.integerConstant(int), String(input[matchRange.upperBound...]))
    }
}

class StringConstantMatcher: Matcher {
    func match(input: String) -> (token: Token, remaining: String)? {
        let regex = "\"(.*)\""
        guard let matchRange = input.tokenMatchRange(regex: regex) else {
            return nil
        }

        return (Token.stringConstant(String(input[matchRange])), String(input[matchRange.upperBound...]))
    }
}
