import Common
import Foundation

/// Generates Jack tokens from raw source code
public class Lexer {

    // MARK: Properties

    let source: String

    // MARK: Lifecycle

    public init(source: String) {
        self.source = source
    }

    // MARK: Methods

    public func getNextToken() throws -> Token? {
        return nil
    }

    public func getAllTokens() throws -> [Token] {
        return []
    }

    // MARK: Private methods

    private func matchWhitespace(in source: String) -> Token? {
        var source = source
        guard !source.isEmpty else {
            return nil
        }
        let whitespaceCharacterSet = NSCharacterSet.whitespacesAndNewlines
        return nil
    }
}
