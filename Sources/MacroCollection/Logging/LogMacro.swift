//
//  LogMacro.swift
//  GoodExtensions-iOS
//
//  Created by Filip Šašala on 09/07/2024.
//

import SwiftSyntax
@_spi(ExperimentalLanguageFeature) import SwiftSyntaxMacros

@_spi(ExperimentalLanguageFeature) public struct LogMacro: BodyMacro {

    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingBodyFor declaration: some SwiftSyntax.DeclSyntaxProtocol & SwiftSyntax.WithOptionalCodeBlockSyntax,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.CodeBlockItemSyntax] {
        let name = context.makeUniqueName("fileName")
        let fileNameDecl = DeclSyntax(
            LoggingShared.buildFileNameDecl(
                uniqueFileNameDeclIdentifier: name
            )
        )
        let printCallExpr = ExprSyntax(
            LoggingShared.buildPrintCallExpr(
                logEvent: .entry,
                uniqueFileNameDeclIdentifier: name
            )
        )
        let printExitCallExpr = ExprSyntax(
            LoggingShared.buildPrintCallExpr(
                logEvent: .exit,
                uniqueFileNameDeclIdentifier: name
            )
        )

        let preambleBody: [CodeBlockItemSyntax] = [
            CodeBlockItemSyntax(item: .decl(fileNameDecl)),
            CodeBlockItemSyntax(item: .expr(printCallExpr)),
            CodeBlockItemSyntax(item: .stmt(StmtSyntax(buildDeferStmt([
                CodeBlockItemSyntax(item: .expr(printExitCallExpr))
            ]))))
        ]

        let functionBody = declaration.body?.statements ?? []

        return preambleBody + functionBody
    }

}

private extension LogMacro {

    static func buildDeferStmt(_ statements: CodeBlockItemListSyntax) -> DeferStmtSyntax {
        DeferStmtSyntax(
            deferKeyword: .keyword(.defer),
            body: CodeBlockSyntax(
                leftBrace: .leftBraceToken(),
                statements: statements,
                rightBrace: .rightBraceToken()
            )
        )
    }

}
