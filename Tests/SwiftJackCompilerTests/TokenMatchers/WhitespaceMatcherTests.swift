//
//  WhitespaceMatcherTests.swift
//  SwiftJackCompilerTests
//
//  Created by pgorzelany on 07/01/2019.
//

@testable import Lexer
import XCTest

class WhitespaceMatcherTests: XCTestCase {

    var matcher: WhitespaceMatcher!

    override func setUp() {
        matcher = WhitespaceMatcher()
    }

    func testMatchingValidInput() {
        let validInputs = [
            "     ",
            "    s sdfsukdhf knd",
            " \n\t ",
            " \n\t asdasd"
        ]

        for input in validInputs {
            let match = matcher.match(input: input)
            XCTAssert(match != nil)
        }
    }

    func testNotMatchingInvalidInput() {
        let invalidInputs = [
            "",
            "s   asds",
            "adsldjasldljasdljas",
            "kahsbdf sdkfb sdkfb"
        ]

        for input in invalidInputs {
            let match = matcher.match(input: input)
            XCTAssert(match == nil)
        }
    }
}
