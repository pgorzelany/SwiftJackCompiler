//
//  SymbolMatcherTests.swift
//  SwiftJackCompilerTests
//
//  Created by pgorzelany on 07/01/2019.
//

@testable import Lexer
@testable import Common
import XCTest

class SymbolMatcherTests: XCTestCase {

    var matcher: SymbolMatcher!

    override func setUp() {
        matcher = SymbolMatcher()
    }

    func testMatchingValidInput() {
        let validInputs = ["{", "}" , "(", ")" , "[", "]" , ".", "," , ";", "+" , "-", "*" , "/", "&" , "|", "<" , ">", "=" , "~",]

        for input in validInputs {
            let match = matcher.match(input: input)
            XCTAssert(match != nil)
        }
    }

}
