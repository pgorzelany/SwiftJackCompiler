import Common
import Foundation

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

        return Match(syntax: identifier, reminder: input[(input.startIndex + 1)...])
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



    func parseKeyword(_ keyword: Keyword, input: Input) -> Match<Keyword>? {
        guard let first = input.first, case let Token.keyword(inputKeyword) = first, keyword == inputKeyword else {
            return nil
        }

        return Match(syntax: keyword, reminder: input[(input.startIndex + 1)...])
    }
}
