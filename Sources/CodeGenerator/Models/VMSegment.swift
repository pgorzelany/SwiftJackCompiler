//
//  VMSegment.swift
//  CodeGenerator
//
//  Created by Piotr Gorzelany on 19/05/2019.
//

import Foundation

enum VMSegment: String {
    case constant, argument, local, `static`, this, that, pointer, temp
}
