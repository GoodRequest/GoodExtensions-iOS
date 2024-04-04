//
//  URLMacro.swift
//  GoodExtensions-iOS
//
//  Created by Filip Šašala on 04/04/2024.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

public struct URLMacro: ExpressionMacro {

    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        guard let argument = node.argumentList.first?.expression,
              let segments = argument.as(StringLiteralExprSyntax.self)?.segments,
              segments.count == 1,
              case .stringSegment(let literalSegment)? = segments.first
        else {
            throw URLMacroError.requiresStaticStringLiteral
        }
        guard URL(string: literalSegment.content.text) != nil else {
            throw URLMacroError.malformedURL(urlString: "\(argument)")
        }

        return "URL(string: \(argument))!"
    }

}

enum URLMacroError: Error, CustomStringConvertible {

    case requiresStaticStringLiteral
    case malformedURL(urlString: String)

    var description: String {
        switch self {
        case .requiresStaticStringLiteral:
            "#URL macro requires a static string literal"

        case .malformedURL(let urlString):
            "URL is malformed: \(urlString)"
        }
    }

}
