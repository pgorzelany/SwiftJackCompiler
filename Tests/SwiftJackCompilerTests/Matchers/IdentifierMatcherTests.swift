//
//  StringLiteralMatcherTests.swift
//  SwiftJackCompilerTests
//
//  Created by pgorzelany on 07/01/2019.
//

@testable import Lexer
import XCTest

class IdentifierMatcherTests: XCTestCase {

    var matcher: IdentifierMatcher!

    override func setUp() {
        matcher = IdentifierMatcher()
    }

    func testMatchingValidInput() {
        var input = "func what"
        var match = matcher.match(input: input)!
        XCTAssert(match.token == .identifier("func"))
        XCTAssert(match.remaining == " what")

        input = "literal x = asdasd"
        match = matcher.match(input: input)!
        XCTAssert(match.token == .identifier("literal"))

        input = "a=b"
        match = matcher.match(input: input)!
        XCTAssert(match.token == .identifier("a"))

        input = "test12 = wow"
        match = matcher.match(input: input)!
        XCTAssert(match.token == .identifier("test12"))
    }

    func testNotMatchingInvalidInput() {
        let invalidInputs = [
            "",
            "    s sdfsukdhf knd",
            " \n\t ",
            " \n\t asdasd",
            "12helloWorld"
        ]

        for input in invalidInputs {
            let match = matcher.match(input: input)
            XCTAssert(match == nil)
        }
    }
}
