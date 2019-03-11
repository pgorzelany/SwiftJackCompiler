//
//  StringConstantMatcherTests.swift
//  SwiftJackCompilerTests
//
//  Created by pgorzelany on 07/01/2019.
//

@testable import Common
@testable import Lexer
import XCTest

class StringConstantMatcherTests: XCTestCase {

    var matcher: StringConstantMatcher!

    override func setUp() {
        matcher = StringConstantMatcher()
    }

    func testMatchingValidInput() {
        var input = "\"fasfdasfsaf\" sfsdf"
        var match = matcher.match(input: input)
        XCTAssert(match != nil)
        XCTAssert(match!.token == Token.stringConstant("\"fasfdasfsaf\""))
        XCTAssert(match!.remaining == " sfsdf")

        input = "\" hello world 1234 sfds \" akuku func x = 0"
        match = matcher.match(input: input)
        XCTAssert(match != nil)
        XCTAssert(match!.token == Token.stringConstant("\" hello world 1234 sfds \""))
        XCTAssert(match!.remaining == " akuku func x = 0")
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
