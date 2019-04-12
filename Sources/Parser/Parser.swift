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

    // MARK: - Program structure

    func parseProgram(_ tokens: [Token]) throws -> [ClassDeclaration] {
        var results: [ClassDeclaration] = []
        var reminder = tokens[...]
        while let match = parseClassDeclaration(input: reminder) {
            results.append(match.syntax)
            reminder = match.reminder
        }

        if !reminder.isEmpty {
            fatalError("The reminder should be empty")
        }

        return results
    }

    func parseClassDeclaration(input: Input) -> Match<ClassDeclaration>? {
        fatalError()
    }

    func parseClassVarDeclaration(input: Input) -> Match<ClassVarDeclaration>? {
        fatalError()
    }

    func parseClassVarType(input: Input) -> Match<ClassVarType>? {
        fatalError()
    }

    func parseType(input: Input) -> Match<Type> {
        fatalError()
    }

    func parseSubroutineDeclaration(input: Input) -> Match<SubroutineDeclaration> {
        fatalError()
    }

    func parseSubroutineDeclarationType(input: Input) -> Match<SubroutineDeclarationType> {
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
}
