import Common
import Foundation

extension ArraySlice where Element == Token {
    func reminder(after index: Index) -> ArraySlice<Element> {
        return self[index...]
    }
}

/// Generates AST from a list of token. Evaluates the gramatical correctness of the code.
public class Parser {

    typealias Input = ArraySlice<Token>
    typealias Matcher<T> = (Input) -> Match<T>?

    // MARK: - Program structure

    func parseProgram(_ tokens: [Token]) throws -> [ClassDeclaration] {
        let (results, reminder) = parseZeroOrMore(input: tokens[...], parser: parseClassDeclaration).toTuple()

        if !reminder.isEmpty {
            fatalError("The reminder should be empty")
        }

        return results
    }

    func parseClassDeclaration(input: Input) -> Match<ClassDeclaration>? {
        guard let (results, reminder) = chainParsers(input: input,
                                               createKeywordParser(.class),
                                               parseClassName,
                                               createSymbolParser("{"),
                                               createZeroOrMoreParser(parser: parseClassVarDeclaration),
                                               createZeroOrMoreParser(parser: parseSubroutineDeclaration),
                                               createSymbolParser("}"))?.toTuple() else {
                                                return nil
        }

        let syntax = ClassDeclaration(className: results.1, classVarDeclarations: results.3, subroutineDeclarations: results.4)

        return Match(syntax: syntax, reminder: reminder)
    }

    func parseClassVarDeclaration(input: Input) -> Match<ClassVarDeclaration>? {
        fatalError()
    }

    func parseClassVarType(input: Input) -> Match<ClassVarType>? {
        fatalError()
    }

    func parseType(input: Input) -> Match<Type>? {
        fatalError()
    }

    func parseSubroutineDeclaration(input: Input) -> Match<SubroutineDeclaration>? {
        fatalError()
    }

    func parseSubroutineDeclarationType(input: Input) -> Match<SubroutineDeclarationType>? {
        fatalError()
    }

    func parseSubroutineReturnType(input: Input) -> Match<SubroutineReturnType>? {
        fatalError()
    }

    func parseParameterList(input: Input) -> Match<ParameterList>? {
        fatalError()
    }

    func parseSubroutineBody(input: Input) -> Match<SubroutineBody>? {
        fatalError()
    }

    func parseVarDeclaration(input: Input) -> Match<VarDeclaration>? {
        fatalError()
    }

    func parseIdentifier(input: Input) -> Match<Identifier>? {
        guard let first = input.first, case let Token.identifier(identifier) = first else {
            return nil
        }

        return Match(syntax: identifier, reminder: input.reminder(after: input.startIndex))
    }

    func parseClassName(input: Input) -> Match<ClassName>? {
        return parseIdentifier(input: input)
    }

    func parseSubroutineName(input: Input) -> Match<SubroutineName>? {
        return parseIdentifier(input: input)
    }

    func parseVarName(input: Input) -> Match<VarName>? {
        return parseIdentifier(input: input)
    }

    // MARK: - Statements

    func parseStatement(input: Input) -> Match<Statement>? {
        fatalError()
    }

    func parseLetStatement(input: Input) -> Match<LetStatement>? {
        fatalError()
    }

    func parseIfStatement(input: Input) -> Match<IfStatement>? {
        fatalError()
    }

    func parseWhileStatement(input: Input) -> Match<WhileStatement>? {
        fatalError()
    }

    func parseDoStatement(input: Input) -> Match<DoStatement>? {
        fatalError()
    }

    func parseReturnStatement(input: Input) -> Match<ReturnStatement>? {
        fatalError()
    }

    // MARK: - Expressions

    func parseExpressionList(input: Input) -> Match<ExpressionList>? {
        fatalError()
    }

    func parseExpression(input: Input) -> Match<Expression>? {
        fatalError()
    }

    func parseTerm(input: Input) -> Match<Term>? {
        fatalError()
    }

    func parseSubroutineCall(input: Input) -> Match<SubroutineCall>? {
        fatalError()
    }

    func parseMethodContext(input: Input) -> Match<MethodContext>? {
        fatalError()
    }

    func parseOperation(input: Input) -> Match<Common.Operation>? {
        fatalError()
    }

    func parseUnaryOperation(input: Input) -> Match<UnaryOperation>? {
        fatalError()
    }

    func parseKeywordConstant(input: Input) -> Match<KeywordConstant>? {
        guard let first = input.first, case let Token.keyword(keyword) = first, let keywordConstant = KeywordConstant(rawValue: keyword.rawValue) else {
            return nil
        }

        return Match(syntax: keywordConstant, reminder: input.reminder(after: input.startIndex))
    }

    // MARK: - Helpers

    func parseKeyword(_ keyword: Keyword, input: Input) -> Match<Keyword>? {
        guard let first = input.first, case let Token.keyword(inputKeyword) = first, keyword == inputKeyword else {
            return nil
        }

        return Match(syntax: keyword, reminder: input.reminder(after: input.startIndex))
    }

    func createKeywordParser(_ keyword: Keyword) -> (Input) -> Match<Keyword>? {
        return { input in
            return self.parseKeyword(keyword, input: input)
        }
    }

    func parseSymbol(_ symbol: String, input: Input) -> Match<String>? {
        guard let first = input.first, case let Token.symbol(inputSymbol) = first, symbol == inputSymbol else {
            return nil
        }

        return Match(syntax: symbol, reminder: input.reminder(after: input.startIndex))
    }

    func createSymbolParser(_ symbol: String) -> (Input) -> Match<String>? {
        return { input in
            return self.parseSymbol(symbol, input: input)
        }
    }

    func parseZeroOrMore<T>(input: Input, parser: Matcher<T>) -> Match<[T]> {
        var results: [T] = []
        var reminder = input[...]
        while let match = parser(reminder) {
            results.append(match.syntax)
            reminder = match.reminder
        }

        return Match(syntax: results, reminder: reminder)
    }

    func createZeroOrMoreParser<T>(parser: @escaping Matcher<T>) -> Matcher<[T]> {
        return { input in
            return self.parseZeroOrMore(input: input, parser: parser)
        }
    }

    func composeParsers<A, B>(_ first: @escaping Matcher<A>, _ second: @escaping Matcher<B>) -> Matcher<(A, B)> {
        return { input in
            guard let firstMatch = first(input), let secondMatch = second(firstMatch.reminder) else {
                return nil
            }

            return Match(syntax: (firstMatch.syntax, secondMatch.syntax), reminder: secondMatch.reminder)
        }
    }

    func composeParsers<A, B, C>(_ first: @escaping Matcher<A>, _ second: @escaping Matcher<B>, _ third: @escaping Matcher<C>) -> Matcher<(A, B, C)> {
        return { input in
            guard let firstMatch = first(input), let secondMatch = second(firstMatch.reminder), let thirdMatch = third(secondMatch.reminder) else {
                return nil
            }

            return Match(syntax: (firstMatch.syntax, secondMatch.syntax, thirdMatch.syntax), reminder: secondMatch.reminder)
        }
    }

    func chainParsers<A, B>(input: Input,
                            _ first: (Input) -> Match<A>?,
                            _ second: (Input) -> Match<B>?) -> Match<(A, B)>? {
        guard let firstMatch = first(input),
            let secondMatch = second(firstMatch.reminder) else {
            return nil
        }

        return Match(syntax: (firstMatch.syntax, secondMatch.syntax),
                     reminder: secondMatch.reminder)
    }

    func chainParsers<A, B, C>(input: Input,
                            _ first: (Input) -> Match<A>?,
                            _ second: (Input) -> Match<B>?,
                            _ third: (Input) -> Match<C>?) -> Match<(A, B, C)>? {
        guard let firstMatch = first(input),
            let secondMatch = second(firstMatch.reminder), let thirdMatch = third(secondMatch.reminder) else {
                return nil
        }

        return Match(syntax: (firstMatch.syntax, secondMatch.syntax, thirdMatch.syntax),
                     reminder: thirdMatch.reminder)
    }

    func chainParsers<A, B, C, D>(input: Input,
                               _ first: (Input) -> Match<A>?,
                               _ second: (Input) -> Match<B>?,
                               _ third: (Input) -> Match<C>?,
                               _ fourth: (Input) -> Match<D>?) -> Match<(A, B, C, D)>? {
        guard let firstMatch = first(input),
            let secondMatch = second(firstMatch.reminder),
            let thirdMatch = third(secondMatch.reminder),
            let fourthMatch = fourth(thirdMatch.reminder) else {
                return nil
        }

        return Match(syntax: (firstMatch.syntax, secondMatch.syntax, thirdMatch.syntax, fourthMatch.syntax),
                     reminder: fourthMatch.reminder)
    }

    func chainParsers<A, B, C, D, E>(input: Input,
                                  _ first: (Input) -> Match<A>?,
                                  _ second: (Input) -> Match<B>?,
                                  _ third: (Input) -> Match<C>?,
                                  _ fourth: (Input) -> Match<D>?,
                                  _ fifth: (Input) -> Match<E>?) -> Match<(A, B, C, D, E)>? {
        guard let firstMatch = first(input),
            let secondMatch = second(firstMatch.reminder),
            let thirdMatch = third(secondMatch.reminder),
            let fourthMatch = fourth(thirdMatch.reminder),
            let fifthMatch = fifth(fourthMatch.reminder) else {
                return nil
        }

        return Match(syntax: (firstMatch.syntax, secondMatch.syntax, thirdMatch.syntax, fourthMatch.syntax, fifthMatch.syntax),
                     reminder: fifthMatch.reminder)
    }

    func chainParsers<A, B, C, D, E, F>(input: Input,
                                     _ first: (Input) -> Match<A>?,
                                     _ second: (Input) -> Match<B>?,
                                     _ third: (Input) -> Match<C>?,
                                     _ fourth: (Input) -> Match<D>?,
                                     _ fifth: (Input) -> Match<E>?,
                                     _ sixth: (Input) -> Match<F>?) -> Match<(A, B, C, D, E, F)>? {
        guard let firstMatch = first(input),
            let secondMatch = second(firstMatch.reminder),
            let thirdMatch = third(secondMatch.reminder),
            let fourthMatch = fourth(thirdMatch.reminder),
            let fifthMatch = fifth(fourthMatch.reminder),
            let sixthMatch = sixth(fifthMatch.reminder) else {
                return nil
        }

        return Match(syntax: (firstMatch.syntax, secondMatch.syntax, thirdMatch.syntax, fourthMatch.syntax, fifthMatch.syntax, sixthMatch.syntax),
                     reminder: sixthMatch.reminder)
    }
}
