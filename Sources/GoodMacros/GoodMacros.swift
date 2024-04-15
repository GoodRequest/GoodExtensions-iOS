//
//  GoodMacros.swift
//  GoodExtensions-iOS
//
//  Created by Filip Šašala on 04/04/2024.
//

import Foundation

@freestanding(expression)
public macro URL(_ string: String) -> URL = #externalMacro(module: "MacroCollection", type: "URLMacro")
