//
//  MacroCollection.swift
//  GoodExtensions-iOS
//
//  Created by Filip Šašala on 04/04/2024.
//

import Foundation
import SwiftCompilerPlugin
@_spi(ExperimentalLanguageFeature) import SwiftSyntaxMacros

@main struct Plugins: CompilerPlugin {

    let providingMacros: [Macro.Type] = [
        URLMacro.self,
        LogMacro.self,
        LoggedMacro.self,
        LogAccessMacro.self
    ]

}
