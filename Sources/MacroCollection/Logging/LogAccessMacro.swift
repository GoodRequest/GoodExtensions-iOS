//
//  LogAccessMacro.swift
//  GoodExtensions-iOS
//
//  Created by Filip Šašala on 10/07/2024.
//

import SwiftSyntax
import SwiftSyntaxMacros

public struct LogAccessMacro: AccessorMacro {

    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingAccessorsOf declaration: some SwiftSyntax.DeclSyntaxProtocol,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.AccessorDeclSyntax] {
        guard let declaration = declaration.as(VariableDeclSyntax.self) else {
            return []
        }

        guard let firstAccessorBlock = declaration.bindings.first?.accessorBlock else {
            return [newWillSetBlock(context: context)]
        }

        switch firstAccessorBlock.accessors {
        case .accessors(let accessorListDeclSyntax):
            let anyWillSet = accessorListDeclSyntax
                .children(viewMode: .all)
                .compactMap { $0.as(AccessorDeclSyntax.self) }
                .filter { $0.accessorSpecifier.tokenKind == .keyword(.willSet) }
                .first

            let anyDidSet = accessorListDeclSyntax
                .children(viewMode: .all)
                .compactMap { $0.as(AccessorDeclSyntax.self) }
                .filter { $0.accessorSpecifier.tokenKind == .keyword(.didSet) }
                .first

            if anyWillSet == nil && anyDidSet != nil {
                return [newWillSetBlock(context: context)]
            } else {
                return []
            }

        case .getter:
            return [] // only getter exists
        }
    }

    static func newWillSetBlock(context macroExpansionContext: some MacroExpansionContext) -> AccessorDeclSyntax{
        let name = macroExpansionContext.makeUniqueName("fileName")
        return AccessorDeclSyntax(
            attributes: [],
            accessorSpecifier: .keyword(.willSet),
            body: CodeBlockSyntax(
                leftBrace: .leftBraceToken(),
                statements: [
                    CodeBlockItemSyntax(
                        item: .decl(
                            DeclSyntax(
                                LoggingShared.buildFileNameDecl(
                                    uniqueFileNameDeclIdentifier: name
                                )
                            )
                        )
                    ),
                    CodeBlockItemSyntax(
                        item: .expr(
                            ExprSyntax(
                                LoggingShared.buildPrintCallExpr(
                                    logEvent: .assignment,
                                    uniqueFileNameDeclIdentifier: name
                                )
                            )
                        )
                    )
                ],
                rightBrace: .rightBraceToken()
            )
        )
    }

}
