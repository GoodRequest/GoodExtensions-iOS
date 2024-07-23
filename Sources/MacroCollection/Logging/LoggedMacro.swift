//
//  LoggedMacro.swift
//  GoodExtensions-iOS
//
//  Created by Filip Šašala on 10/07/2024.
//

import SwiftSyntax
import SwiftSyntaxMacros

public struct LoggedMacro: MemberAttributeMacro {

    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingAttributesFor member: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AttributeSyntax] {
        switch member.kind {
        case .functionDecl, .initializerDecl:
            return [AttributeSyntax(
                atSign: .atSignToken(),
                attributeName: IdentifierTypeSyntax(name: .identifier("Log"))
            )]

        case .variableDecl:
            return [AttributeSyntax(
                atSign: .atSignToken(),
                attributeName: IdentifierTypeSyntax(name: .identifier("LogAccess"))
            )]

        default:
            return []
        }
    }

}
