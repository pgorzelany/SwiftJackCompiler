//
//  SymbolEntry.swift
//  CodeGenerator
//
//  Created by Piotr Gorzelany on 19/05/2019.
//

import Foundation

struct SymbolEntry: Equatable {
    let symbol: Symbol
    let kindIndex: Int
}

extension SymbolEntry: Hashable {
    func hash(into hasher: inout Hasher) {
        symbol.name.hash(into: &hasher)
    }
}
