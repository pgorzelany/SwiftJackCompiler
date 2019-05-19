//
//  SymbolTable.swift
//  CodeGenerator
//
//  Created by Piotr Gorzelany on 19/05/2019.
//

import Foundation
import Common

class SymbolTable {

    private var entries: Set<SymbolEntry> = []

    func addSymbol(_ symbol: Symbol) {
        let sameKindEntriesCount = entries.filter({$0.symbol.kind == symbol.kind}).count
        let entry: SymbolEntry
        if sameKindEntriesCount == 0 {
            entry = SymbolEntry(symbol: symbol, kindIndex: 0)
        } else {
            entry = SymbolEntry(symbol: symbol, kindIndex: sameKindEntriesCount + 1)
        }

        guard !entries.contains(entry) else {
            fatalError("Duplicated symbol")
        }

        entries.insert(entry)
    }

    func getEntry(for symbolName: String) -> SymbolEntry? {
        return entries.first(where: {$0.symbol.name == symbolName})
    }
}
