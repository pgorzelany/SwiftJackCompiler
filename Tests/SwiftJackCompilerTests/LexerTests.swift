//
//  LexerTests.swift
//  SwiftJackCompilerTests
//
//  Created by pgorzelany on 07/01/2019.
//

@testable import Lexer
import XCTest

class LexerTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        let lexer = Lexer(source: "hello")
    }
}
