//
//  LexerTests.swift
//  SwiftJackCompilerTests
//
//  Created by pgorzelany on 07/01/2019.
//

@testable import Lexer
import XCTest

class LexerTests: XCTestCase {

    var lexer: Lexer!

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
            XCTAssert(tokens.count > 0)
            print(tokens)
        } catch {
            XCTAssert(false)
        }
    }
}
