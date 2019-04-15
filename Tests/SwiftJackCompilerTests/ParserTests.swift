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

//    func testParsingValidProgram() {
//        let source = """
//                    class Main {
//                       function void main() {
//                          var Array a;
//                          var int length;
//                          var int i, sum;
//
//                          let length = Keyboard.readInt("How many numbers? ");
//                          let a = Array.new(length);
//
//                          let i = 0;
//                          while (i < length) {
//                             let a[i] = Keyboard.readInt("Enter a number: ");
//                             let sum = sum + a[i];
//                             let i = i + 1;
//                          }
//
//                          do Output.printString("The average is ");
//                          do Output.printInt(sum / length);
//                          return;
//                       }
//                    }
//                    """
//        lexer = Lexer(source: source)
//        do {
//            let tokens = try lexer.getAllTokens()
//            let results = try parser.parseProgram(tokens)
//            XCTAssert(results.count == 1)
//        } catch {
//            XCTAssert(false)
//        }
//    }

    func testParsingComplexValidClass() {
        let source = """
                    class SquareGame {
                       field Square square; // the square of this game
                       field int direction; // the square's current direction:
                                            // 0=none, 1=up, 2=down, 3=left, 4=right

                       /** Constructs a new Square Game. */
                       constructor SquareGame new() {
                          // Creates a 30 by 30 pixels square and positions it at the top-left
                          // of the screen.
                          let square = Square.new(0, 0, 30);
                          let direction = 0;  // initial state is no movement
                          return this;
                       }

                       /** Disposes this game. */
                       method void dispose() {
                          do square.dispose();
                          do Memory.deAlloc(this);
                          return;
                       }

                       /** Moves the square in the current direction. */
                       method void moveSquare() {
                          if (direction = 1) { do square.moveUp(); }
                          if (direction = 2) { do square.moveDown(); }
                          if (direction = 3) { do square.moveLeft(); }
                          if (direction = 4) { do square.moveRight(); }
                          do Sys.wait(5);  // delays the next movement
                          return;
                       }

                       /** Runs the game: handles the user's inputs and moves the square accordingly */
                       method void run() {
                          var char key;  // the key currently pressed by the user
                          var boolean exit;
                          let exit = false;

                          while (~exit) {
                             // waits for a key to be pressed
                             while (key = 0) {
                                let key = Keyboard.keyPressed();
                                do moveSquare();
                             }
                             if (key = 81)  { let exit = true; }     // q key
                             if (key = 90)  { do square.decSize(); } // z key
                             if (key = 88)  { do square.incSize(); } // x key
                             if (key = 131) { let direction = 1; }   // up arrow
                             if (key = 133) { let direction = 2; }   // down arrow
                             if (key = 130) { let direction = 3; }   // left arrow
                             if (key = 132) { let direction = 4; }   // right arrow

                             // waits for the key to be released
                             while (~(key = 0)) {
                                let key = Keyboard.keyPressed();
                                do moveSquare();
                             }
                         } // while
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
