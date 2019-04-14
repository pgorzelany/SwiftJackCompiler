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
            XCTAssert(tokens.count == 108)
            print(tokens)
        } catch {
            XCTAssert(false)
        }
    }

    func testTokenizingValidProgramWithComment() {
        let source = """
                    // This file is part of www.nand2tetris.org
                    // and the book "The Elements of Computing Systems"
                    // by Nisan and Schocken, MIT Press.
                    // File name: projects/09/HelloWorld/Main.jack

                    /** Hello World program. */
                    class Main {
                       function void main() {
                          /* Prints some text using the standard library. */
                          do Output.printString("Hello world!");
                          do Output.println();      // New line
                          return;
                       }
                    }
                    """
        lexer = Lexer(source: source)
        do {
            let tokens = try lexer.getAllTokens()
            XCTAssert(tokens.count == 28)
            print(tokens)
        } catch {
            XCTAssert(false)
        }
    }
}
