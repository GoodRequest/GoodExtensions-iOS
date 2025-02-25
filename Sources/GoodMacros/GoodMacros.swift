//
//  GoodMacros.swift
//  GoodExtensions-iOS
//
//  Created by Filip Šašala on 04/04/2024.
//

import Foundation

@freestanding(expression)
public macro URL(_ string: String) -> URL = #externalMacro(module: "MacroCollection", type: "URLMacro")

@attached(body)
public macro Log() = #externalMacro(module: "MacroCollection", type: "LogMacro")

@attached(memberAttribute)
public macro Logged() = #externalMacro(module: "MacroCollection", type: "LoggedMacro")

//@attached(accessor, names: named(willSet))
//public macro LogAccess() = #externalMacro(module: "MacroCollection", type: "LogAccessMacro")
