//
//  ASTNode.swift
//  CodeGenerator
//
//  Created by pgorzelany on 10/01/2019.
//

import Foundation

// MARK:  Program structure

public struct ClassDeclaration {
    let className: ClassName
    let classVarDeclaration: [ClassVarDeclaration]
    let subroutineDeclarations: [SubroutineDeclaration]
}

public struct ClassVarDeclaration {
    let classVarType: ClassVarType
    let type: Type
    let varName: VarName
    let additionalVarNames: [VarName]
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
}

public enum SubroutineDeclarationType: String {
    case constructor, function, method
}

public enum SubroutineReturnType {
    case void
    case type(Type)
}

public struct ParameterList {
    let parameters: [(Type, VarName)]
}

public struct SubroutineBody {
    let varDeclarations: [VarDeclaration]
    let statements: [Statement]
}

public struct VarDeclaration {

}

public struct Identifier {
}

public typealias ClassName = Identifier
public typealias SubroutineName = Identifier
public typealias VarName = Identifier

// MARK: Statements

public enum Statement {
    case letStatement(LetStatement)
    case ifStatement(IfStatement)
    case whileStatement(WhileStatement)
    case doStatement(DoStatement)
    case returnStatement(ReturnStatement)
}

public struct LetStatement {
}

public struct IfStatement {
}

public struct WhileStatement {
}

public struct DoStatement {
}

public struct ReturnStatement {
}

// MARK: Expressions

public struct Expression {
    let lhs: Term
    let rhs: [(Operation, Term)]
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
    case function
    case method
}

public typealias ExpressionList = [Expression]

public enum Operation {
    // TODO
    case addition
}

public enum UnaryOperation {
    // TODO
    case somethin
}

public enum KeywordConstant: String {
    case `true`
    case `false`
    case `null`
    case `this`
}
