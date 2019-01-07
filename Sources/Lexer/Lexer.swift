import Common
import Foundation

/// Generates Jack tokens from raw source code
public class Lexer {

    // MARK: Properties

    let source: String
    var remainingSource: String
    let matchers: [Matcher] = [
        WhitespaceMatcher(),
        KeywordMatcher(),
        SymbolMatcher(),
        StringConstantMatcher(),
        IntegerConstantMatcher(),
        IdentifierMatcher()
    ]

    // MARK: Lifecycle

    public init(source: String) {
        self.source = source
        self.remainingSource = source
    }

    // MARK: Methods

    public func getNextToken() throws -> Token? {
        guard !remainingSource.isEmpty else {
            return nil
        }
        
        for matcher in matchers {
            if let (token, remaining) = matcher.match(input: remainingSource) {
                self.remainingSource = remaining
                return token
            }
        }
        return nil
    }

    public func getAllTokens() throws -> [Token] {
        var results: [Token] = []
        while let nextToken = try getNextToken() {
            results.append(nextToken)
        }
        return results
    }
}
