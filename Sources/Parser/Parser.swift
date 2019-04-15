import Common
import Foundation

extension ArraySlice where Element == Token {
    func reminder(after index: Index) -> ArraySlice<Element> {
        return self[(index + 1)...]
    }
}

/// Generates AST from a list of tokens. Evaluates the gramatical correctness of the code.
public class Parser {

    typealias Input = ArraySlice<Token>
    typealias Matcher<T> = (Input) -> Match<T>?

    public init() {}

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
        let additionalVarNamesParser = createZeroOrMoreParser(parser: composeParsers(createSymbolParser(","), parseVarName))
        guard let (results, reminder) = chainParsers(input: input,
                                                     parseClassVarType,
                                                     parseType,
                                                     parseVarName,
                                                     additionalVarNamesParser,
                                                     createSymbolParser(";"))?.toTuple() else {
            return nil
        }

        let syntax = ClassVarDeclaration(classVarType: results.0, type: results.1, varName: results.2, additionalVarNames: results.3.map{ $0.1 })
        return Match(syntax: syntax, reminder: reminder)
    }

    func parseClassVarType(input: Input) -> Match<ClassVarType>? {
        if let staticMatch = parseKeyword(.static, input: input) {
            return Match(syntax: ClassVarType.static, reminder: staticMatch.reminder)
        } else if let fieldMatch = parseKeyword(.field, input: input) {
            return Match(syntax: ClassVarType.field, reminder: fieldMatch.reminder)
        }

        return nil
    }

    func parseType(input: Input) -> Match<Type>? {
        if let intMatch = parseKeyword(.int, input: input) {
            return Match(syntax: Type.int, reminder: intMatch.reminder)
        } else if let charMatch = parseKeyword(.char, input: input) {
            return Match(syntax: Type.char, reminder: charMatch.reminder)
        } else if let booleanMatch = parseKeyword(.boolean, input: input) {
            return Match(syntax: Type.boolean, reminder: booleanMatch.reminder)
        } else if let classNameMatch = parseClassName(input: input) {
            return Match(syntax: Type.class(classNameMatch.syntax), reminder: classNameMatch.reminder)
        }

        return nil
    }

    func parseSubroutineDeclaration(input: Input) -> Match<SubroutineDeclaration>? {
        let parameterListParser = composeParsers(createSymbolParser("("), parseParameterList, createSymbolParser(")"))
        guard let (results, reminder) = chainParsers(input: input,
                                                     parseSubroutineDeclarationType,
                                                     parseSubroutineReturnType,
                                                     parseSubroutineName,
                                                     parameterListParser,
                                                     parseSubroutineBody)?.toTuple() else {
            return nil
        }

        let syntax = SubroutineDeclaration(declarationType: results.0, returnType: results.1, name: results.2, parameterList: results.3.1, body: results.4)

        return Match(syntax: syntax, reminder: reminder)
    }

    func parseSubroutineDeclarationType(input: Input) -> Match<SubroutineDeclarationType>? {
        if let constructorMatch = parseKeyword(.constructor, input: input) {
            return Match(syntax: SubroutineDeclarationType.constructor, reminder: constructorMatch.reminder)
        } else if let functionMatch = parseKeyword(.function, input: input) {
            return Match(syntax: SubroutineDeclarationType.function, reminder: functionMatch.reminder)
        } else if let methodMatch = parseKeyword(.method, input: input) {
            return Match(syntax: SubroutineDeclarationType.method, reminder: methodMatch.reminder)
        }

        return nil
    }

    func parseSubroutineReturnType(input: Input) -> Match<SubroutineReturnType>? {
        if let voidMatch = parseKeyword(.void, input: input) {
            return Match(syntax: SubroutineReturnType.void, reminder: voidMatch.reminder)
        } else if let typeMatch = parseType(input: input) {
            return Match(syntax: SubroutineReturnType.type(typeMatch.syntax), reminder: typeMatch.reminder)
        }

        return nil
    }

    func parseParameterList(input: Input) -> Match<ParameterList>? {
        let varNameParser = composeParsers(parseType, parseVarName)
        let additionalVarNamesParser = createZeroOrMoreParser(parser: composeParsers(createSymbolParser(","), parseType, parseVarName))
        if let (results, reminder) = chainParsers(input: input, varNameParser, additionalVarNamesParser)?.toTuple() {
            let firstVar = results.0
            let additionalVars = results.1.map({($0.1, $0.2)})
            return Match(syntax: ParameterList(parameters: [firstVar] + additionalVars), reminder: reminder)
        }
        return Match(syntax: ParameterList(parameters: nil), reminder: input)
    }

    func parseSubroutineBody(input: Input) -> Match<SubroutineBody>? {
        let varDeclarationsParser = createZeroOrMoreParser(parser: parseVarDeclaration)
        let statementsParser = createZeroOrMoreParser(parser: parseStatement)
        guard let (results, reminder) = chainParsers(input: input, createSymbolParser("{"), varDeclarationsParser, statementsParser, createSymbolParser("}"))?.toTuple() else {
            return nil
        }

        let syntax = SubroutineBody(varDeclarations: results.1, statements: results.2)
        return Match(syntax: syntax, reminder: reminder)
    }

    func parseVarDeclaration(input: Input) -> Match<VarDeclaration>? {
        let additionalVarNamesParser = createZeroOrMoreParser(parser: composeParsers(createSymbolParser(","), parseVarName))
        guard let (results, reminder) = chainParsers(input: input,
                                                     createKeywordParser(.var),
                                                     parseType,
                                                     parseVarName,
                                                     additionalVarNamesParser,
                                                     createSymbolParser(";"))?.toTuple() else {
            return nil
        }

        let syntax = VarDeclaration(type: results.1, requiredVarName: results.2, additionalVarNames: results.3.map({ $0.1 }))

        return Match(syntax: syntax, reminder: reminder)
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

    func parseStatements(input: Input) -> Match<[Statement]>? {
        return parseZeroOrMore(input: input, parser: parseStatement)
    }

    func parseStatement(input: Input) -> Match<Statement>? {
        if let letStatementMatch = parseLetStatement(input: input) {
            return Match(syntax: Statement.letStatement(letStatementMatch.syntax), reminder: letStatementMatch.reminder)
        } else if let ifStatementMatch = parseIfStatement(input: input) {
            return Match(syntax: Statement.ifStatement(ifStatementMatch.syntax), reminder: ifStatementMatch.reminder)
        } else if let whileStatementMatch = parseWhileStatement(input: input) {
            return Match(syntax: Statement.whileStatement(whileStatementMatch.syntax), reminder: whileStatementMatch.reminder)
        } else if let doStatementMatch = parseDoStatement(input: input) {
            return Match(syntax: Statement.doStatement(doStatementMatch.syntax), reminder: doStatementMatch.reminder)
        } else if let returnStatementMatch = parseReturnStatement(input: input) {
            return Match(syntax: Statement.returnStatement(returnStatementMatch.syntax), reminder: returnStatementMatch.reminder)
        }

        return nil
    }

    func parseLetStatement(input: Input) -> Match<LetStatement>? {
        let subscriptExpressionParser = createZeroOrOneParser(parser: composeParsers(createSymbolParser("["), parseExpression, createSymbolParser("]")))
        guard let (results, reminder) = chainParsers(input: input,
                                                     createKeywordParser(.let),
                                                     parseVarName,
                                                     subscriptExpressionParser,
                                                     createSymbolParser("="),
                                                     parseExpression,
                                                     createSymbolParser(";"))?.toTuple() else {
            return nil
        }

        let syntax = LetStatement(varName: results.1, subscript: results.2?.1, expression: results.4)
        return Match(syntax: syntax, reminder: reminder)
    }

    func parseIfStatement(input: Input) -> Match<IfStatement>? {
        let conditionParser = composeParsers(createSymbolParser("("), parseExpression, createSymbolParser(")"))
        let thenParser = composeParsers(createSymbolParser("{"), parseStatements, createSymbolParser("}"))
        let elseParser = createZeroOrOneParser(parser: parseElseStatement)
        guard let (results, reminder) = chainParsers(input: input,
                                                     createKeywordParser(.if),
                                                     conditionParser,
                                                     thenParser,
                                                     elseParser)?.toTuple() else {
            return nil
        }

        let syntax = IfStatement(condition: results.1.1, then: results.2.1, else: results.3)
        return Match(syntax: syntax, reminder: reminder)
    }

    func parseElseStatement(input: Input) -> Match<[Statement]>? {
        guard let (results, reminder) = chainParsers(input: input,
                                                     createKeywordParser(.else),
                                                     createSymbolParser("{"),
                                                     parseStatements,
                                                     createSymbolParser("}"))?.toTuple() else {
            return nil
        }

        return Match(syntax: results.2, reminder: reminder)
    }

    func parseWhileStatement(input: Input) -> Match<WhileStatement>? {
        let conditionParser = composeParsers(createSymbolParser("("), parseExpression, createSymbolParser(")"))
        guard let (results, reminder) = chainParsers(input: input,
                                                     createKeywordParser(.while),
                                                     conditionParser,
                                                     createSymbolParser("{"),
                                                     parseStatements,
                                                     createSymbolParser("}"))?.toTuple() else {
            return nil
        }

        let syntax = WhileStatement(condition: results.1.1, body: results.3)
        return Match(syntax: syntax, reminder: reminder)
    }

    func parseDoStatement(input: Input) -> Match<DoStatement>? {
        guard let (results, reminder) = chainParsers(input: input, createKeywordParser(.do), parseSubroutineCall, createSymbolParser(";"))?.toTuple() else {
            return nil
        }

        let syntax = DoStatement(subroutineCall: results.1)
        return Match(syntax: syntax, reminder: reminder)
    }

    func parseReturnStatement(input: Input) -> Match<ReturnStatement>? {
        guard let (results, reminder) = chainParsers(input: input,
                                                     createKeywordParser(.return),
                                                     createZeroOrOneParser(parser: parseExpression),
                                                     createSymbolParser(";"))?.toTuple() else {
                                                        return nil
        }

        let syntax = ReturnStatement(returnExpression: results.1)
        return Match(syntax: syntax, reminder: reminder)
    }

    // MARK: - Expressions

    func parseExpression(input: Input) -> Match<Expression>? {
        guard let (results, reminder) = chainParsers(input: input,
                                                     parseTerm,
                                                     createZeroOrMoreParser(parser: composeParsers(parseOperation, parseTerm)))?.toTuple() else {
                                                        return nil
        }

        let syntax = Expression(lhs: results.0, rhs: results.1)
        return Match(syntax: syntax, reminder: reminder)
    }

    func parseTerm(input: Input) -> Match<Term>? {
        guard let first = input.first else {
            return nil
        }

        let subscriptExpressionParser = composeParsers(createSymbolParser("["),
                                                       parseExpression,
                                                       createSymbolParser("]"))
        let groupedExpressionParser = composeParsers(createSymbolParser("("),
                                                     parseExpression,
                                                     createSymbolParser(")"))

        #warning("Probably need to rearange the methods so everything parses correctly in order")
        if case let Token.integerConstant(integer) = first {
            return Match(syntax: Term.integerConstant(integer), reminder: input.reminder(after: input.startIndex))
        } else if case let Token.stringConstant(string) = first {
            return Match(syntax: Term.stringConstant(string), reminder: input.reminder(after: input.startIndex))
        } else if case let Token.keyword(keyword) = first, let keywordConstant = KeywordConstant(rawValue: keyword.rawValue) {
            return Match(syntax: Term.keywordConstant(keywordConstant), reminder: input.reminder(after: input.startIndex))
        } else if let (results, reminder) = chainParsers(input: input, parseIdentifier, subscriptExpressionParser)?.toTuple() {
            let syntax = Term.subscript(results.0, results.1.1)
            return Match(syntax: syntax, reminder: reminder)
        } else if let subroutineCallMatch = parseSubroutineCall(input: input) {
            let syntax = Term.subroutineCall(subroutineCallMatch.syntax)
            return Match(syntax: syntax, reminder: subroutineCallMatch.reminder)
        } else if let expressionGroupMatch = groupedExpressionParser(input) {
            let syntax = Term.group(expressionGroupMatch.syntax.1)
            return Match(syntax: syntax, reminder: expressionGroupMatch.reminder)
        } else if let (results, reminder) = chainParsers(input: input, parseUnaryOperator, parseTerm)?.toTuple() {
            let syntax = Term.operation(results.0, results.1)
            return Match(syntax: syntax, reminder: reminder)
        } else if let varNameMatch = parseIdentifier(input: input) {
            let syntax = Term.varName(varNameMatch.syntax)
            return Match(syntax: syntax, reminder: varNameMatch.reminder)
        }

        return nil
    }

    func parseSubroutineCall(input: Input) -> Match<SubroutineCall>? {
        let expressionListParser = composeParsers(createSymbolParser("("), parseExpressionList, createSymbolParser(")"))
        if let (results, reminder) = chainParsers(input: input, parseSubroutineName, expressionListParser)?.toTuple() {
            let syntax = SubroutineCall.function(results.0, results.1.1)
            return Match(syntax: syntax, reminder: reminder)
        } else if let (results, reminder) = chainParsers(input: input, parseIdentifier, createSymbolParser("."), parseSubroutineName, expressionListParser)?.toTuple() {
            let syntax = SubroutineCall.method(results.0, results.2, results.3.1)
            return Match(syntax: syntax, reminder: reminder)
        }

        return nil
    }

    func parseExpressionList(input: Input) -> Match<ExpressionList>? {
        let additionalExpressionsParser = createZeroOrMoreParser(parser: composeParsers(createSymbolParser(","), parseExpression))
        let parser = composeParsers(parseExpression, additionalExpressionsParser)
        guard let (results, reminder) = parser(input)?.toTuple() else {
            return Match(syntax: ExpressionList(expressions: nil), reminder: input)
        }

        let syntax = ExpressionList(expressions: (results.0, results.1.map({$0.1})))
        return Match(syntax: syntax, reminder: reminder)
    }

    func parseOperation(input: Input) -> Match<Operator>? {
        guard let first = input.first, case let Token.symbol(symbol) = first, let `operator` = Operator(rawValue: symbol) else {
            return nil
        }

        return Match(syntax: `operator`, reminder: input.reminder(after: input.startIndex))
    }

    func parseUnaryOperator(input: Input) -> Match<UnaryOperator>? {
        guard let first = input.first, case let Token.symbol(symbol) = first, let unaryOperator = UnaryOperator(rawValue: symbol) else {
            return nil
        }

        return Match(syntax: unaryOperator, reminder: input.reminder(after: input.startIndex))
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

    func parseZeroOrOne<T>(input: Input, parser: Matcher<T>) -> Match<T?> {
        if let match = parser(input) {
            return Match(syntax: match.syntax, reminder: match.reminder)
        }

        return Match(syntax: nil, reminder: input)
    }

    func createZeroOrOneParser<T>(parser: @escaping Matcher<T>) -> Matcher<T?> {
        return { input in
            return self.parseZeroOrOne(input: input, parser: parser)
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

            return Match(syntax: (firstMatch.syntax, secondMatch.syntax, thirdMatch.syntax), reminder: thirdMatch.reminder)
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
