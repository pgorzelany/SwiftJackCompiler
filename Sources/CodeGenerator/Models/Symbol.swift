//
//  Symbol.swift
//  CodeGenerator
//
//  Created by Piotr Gorzelany on 19/05/2019.
//

import Foundation

struct Symbol: Equatable {
    let name: String
    let type: SymbolType
    let kind: SymbolKind
}
