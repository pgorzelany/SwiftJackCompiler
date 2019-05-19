//
//  VMCommandGenerator.swift
//  CodeGenerator
//
//  Created by Piotr Gorzelany on 19/05/2019.
//

import Foundation

class VMCommandGenerator {

    func generatePushCommand(segment: VMSegment, index: Int?) -> String {
        fatalError()
    }

    func generatePopCommand(segment: VMSegment, index: Int?) -> String {
        fatalError()
    }

    func generateAritmeticCommand(aritmetic: VMAritmetic) -> String {
        fatalError()
    }

    func generateLabelCommand(label: String) -> String {
        fatalError()
    }

    func generateGotoCommand(label: String) -> String {
        fatalError()
    }

    func generateIfCommand(label: String) -> String {
        fatalError()
    }

    func generateCallCommand(name: String, numberOfAguments: Int) -> String {
        fatalError()
    }

    func generateFunctionCommand(name: String, numberOfLocals: Int) -> String {
        fatalError()
    }

    func writeReturn() -> String {
        fatalError()
    }
}
