//
//  KeywordMatcherTests.swift
//  SwiftJackCompilerTests
//
//  Created by pgorzelany on 07/01/2019.
//

@testable import Lexer
@testable import Common
import XCTest

class KeywordMatcherTests: XCTestCase {

    var matcher: KeywordMatcher!

    override func setUp() {
        matcher = KeywordMatcher()
    }

    func testMatchingValidInput() {
        let validInputs = Keyword.allCases.map {$0.rawValue}

        for input in validInputs {
            let match = matcher.match(input: input)
            XCTAssert(match != nil)
        }
    }

    func testNotMatchingInvalidInput() {
        let invalidInputs = [
            "",
            "    s sdfsukdhf knd",
            " \n\t ",
            " \n\t asdasd",
            "12helloWorld",
            "asdasd var",
            " var",
            "varum",
            "varum function" // this will fail
        ]

        for input in invalidInputs {
            let match = matcher.match(input: input)
            XCTAssert(match == nil)
        }
    }
}
