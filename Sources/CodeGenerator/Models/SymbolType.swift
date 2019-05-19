//
//  SymbolType.swift
//  CodeGenerator
//
//  Created by Piotr Gorzelany on 19/05/2019.
//

import Foundation

enum SymbolType: Equatable {
    case int, char, boolean
    case `class`(String)
}
