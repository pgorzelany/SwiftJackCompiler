//
//  ParseResult.swift
//  Parser
//
//  Created by Piotr Gorzelany on 12/04/2019.
//

import Common
import Foundation

struct Match<T> {
    let syntax: T
    let reminder: Parser.Input

    func toTuple() -> (syntax: T, reminder: Parser.Input) {
        return (syntax: syntax, reminder: reminder)
    }
}
