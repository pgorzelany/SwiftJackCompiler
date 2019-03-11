//
//  IntegerConstantMatcherTests.swift
//  SwiftJackCompilerTests
//
//  Created by pgorzelany on 07/01/2019.
//

@testable import Lexer
import XCTest

class IntegerConstantMatcherTests: XCTestCase {

    var matcher: IntegerConstantMatcher!

    override func setUp() {
        matcher = IntegerConstantMatcher()
    }

    func testMatchingValidInput() {
        let validInputs = [
            "0", "123", "32767", "32767 sdfsdfsd"
        ]

        for input in validInputs {
            let match = matcher.match(input: input)
            XCTAssert(match != nil)
        }
    }

    func testNotMatchingInvalidInput() {
        let invalidInputs = [
            "",
            " 123123",
            "var 123",
            "1221234234",
            "123abc23" // this is to be fixed
        ]

        for input in invalidInputs {
            let match = matcher.match(input: input)
            XCTAssert(match == nil)
        }
    }
}
