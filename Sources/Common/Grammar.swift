//
//  ASTNode.swift
//  CodeGenerator
//
//  Created by pgorzelany on 10/01/2019.
//

import Foundation

// MARK: - Program structure

public struct ClassDeclaration {
    let className: ClassName
    let classVarDeclarations: [ClassVarDeclaration]
    let subroutineDeclarations: [SubroutineDeclaration]

    public init(className: ClassName, classVarDeclarations: [ClassVarDeclaration], subroutineDeclarations: [SubroutineDeclaration]) {
        self.className = className
        self.classVarDeclarations = classVarDeclarations
        self.subroutineDeclarations = subroutineDeclarations
    }
}

public struct ClassVarDeclaration {
    let classVarType: ClassVarType
    let type: Type
    let varName: VarName
    let additionalVarNames: [VarName]

    public init(classVarType: ClassVarType, type: Type, varName: VarName, additionalVarNames: [VarName]) {
        self.classVarType = classVarType
        self.type = type
        self.varName = varName
        self.additionalVarNames = additionalVarNames
    }
}

public enum ClassVarType: String {
    case `static`, field
}

public enum Type {
    case int, char, boolean
    case `class`(ClassName)
}

public struct SubroutineDeclaration {
    let declarationType: SubroutineDeclarationType
    let returnType: SubroutineReturnType
    let name: SubroutineName
    let parameterList: ParameterList
    let body: SubroutineBody

    public init(declarationType: SubroutineDeclarationType, returnType: SubroutineReturnType, name: SubroutineName, parameterList: ParameterList, body: SubroutineBody) {
        self.declarationType = declarationType
        self.returnType = returnType
        self.name = name
        self.parameterList = parameterList
        self.body = body
    }
}

public enum SubroutineDeclarationType: String {
    case constructor, function, method
}

public enum SubroutineReturnType {
    case void
    case type(Type)
}

public struct ParameterList {
    let parameters: [(Type, VarName)]?

    public init(parameters: [(Type, VarName)]?) {
        self.parameters = parameters
    }
}

public struct SubroutineBody {
    let varDeclarations: [VarDeclaration]
    let statements: [Statement]

    public init(varDeclarations: [VarDeclaration], statements: [Statement]) {
        self.varDeclarations = varDeclarations
        self.statements = statements
    }
}

public struct VarDeclaration {
    let type: Type
    let requiredVarName: VarName
    let additionalVarNames: [VarName]

    public init(type: Type, requiredVarName: VarName, additionalVarNames: [VarName]) {
        self.type = type
        self.requiredVarName = requiredVarName
        self.additionalVarNames = additionalVarNames
    }
}

public typealias Identifier = String

public typealias ClassName = Identifier
public typealias SubroutineName = Identifier
public typealias VarName = Identifier

// MARK: - Statements

public enum Statement {
    case letStatement(LetStatement)
    case ifStatement(IfStatement)
    case whileStatement(WhileStatement)
    case doStatement(DoStatement)
    case returnStatement(ReturnStatement)
}

public struct LetStatement {
    let varName: VarName
    let `subscript`: Expression?
    let expression: Expression

    public init(varName: VarName, `subscript`: Expression?, expression: Expression) {
        self.varName = varName
        self.subscript = `subscript`
        self.expression = expression
    }
}

public struct IfStatement {
    let condition: Expression
    let then: [Statement]
    let `else`: [Statement]?

    public init(condition: Expression, then: [Statement], `else`: [Statement]?) {
        self.condition = condition
        self.then = then
        self.else = `else`
    }
}

public struct WhileStatement {
    let condition: Expression
    let body: [Statement]

    public init(condition: Expression, body: [Statement]) {
        self.condition = condition
        self.body = body
    }
}

public struct DoStatement {
    let subroutineCall: SubroutineCall

    public init(subroutineCall: SubroutineCall) {
        self.subroutineCall = subroutineCall
    }
}

public struct ReturnStatement {
    let returnExpression: Expression?

    public init(returnExpression: Expression?) {
        self.returnExpression = returnExpression
    }
}

// MARK: - Expressions

public struct Expression {
    let lhs: Term
    let rhs: [(Operator, Term)]

    public init(lhs: Term, rhs: [(Operator, Term)]) {
        self.lhs = lhs
        self.rhs = rhs
    }
}

public indirect enum Term {
    case integerConstant(Int16)
    case stringConstant(String)
    case keywordConstant(KeywordConstant)
    case varName(VarName)
    case `subscript`(VarName, Expression)
    case group(Expression)
    case operation(UnaryOperation, Term)
}

public enum SubroutineCall {
    case function(SubroutineName, ExpressionList)
    case method(Identifier, SubroutineName, ExpressionList)
}

public struct ExpressionList {
    let expressions: (required: Expression, additional: [Expression])?

    public init(expressions: (Expression, [Expression])?) {
        self.expressions = expressions
    }
}

public enum Operator: String {
    case addition = "+"
    case subtraction = "-"
    case multiplication = "*"
    case division = "/"
    case and = "&"
    case or = "|"
    case letThan = "<"
    case greaterThan = ">"
    case equal = "="
}

public enum UnaryOperation: String {
    case minus = "-"
    case tilde = "~"
}

public enum KeywordConstant: String {
    case `true`
    case `false`
    case `null`
    case `this`
}
