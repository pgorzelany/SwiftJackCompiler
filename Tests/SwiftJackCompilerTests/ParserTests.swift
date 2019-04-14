//
//  ParserTests.swift
//  SwiftJackCompilerTests
//
//  Created by pgorzelany on 11/01/2019.
//

@testable import Lexer
@testable import Parser
import XCTest

class ParserTests: XCTestCase {

    var lexer: Lexer!
    let parser = Parser()

    func testTokenizingValidProgram() {
        let source = """
                    class Main {
                       function void main() {
                          var Array a;
                          var int length;
                          var int i, sum;

                          let length = Keyboard.readInt("How many numbers? ");
                          let a = Array.new(length);

                          let i = 0;
                          while (i < length) {
                             let a[i] = Keyboard.readInt("Enter a number: ");
                             let sum = sum + a[i];
                             let i = i + 1;
                          }

                          do Output.printString("The average is ");
                          do Output.printInt(sum / length);
                          return;
                       }
                    }
                    """
        lexer = Lexer(source: source)
        do {
            let tokens = try lexer.getAllTokens()
            let results = try parser.parseProgram(tokens)
            XCTAssert(results.count == 1)
        } catch {
            XCTAssert(false)
        }
    }

}
