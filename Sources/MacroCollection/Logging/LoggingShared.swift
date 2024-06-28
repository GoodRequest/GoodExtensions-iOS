//
//  LoggingShared.swift
//  
//
//  Created by Filip Šašala on 10/07/2024.
//

import SwiftSyntax
import SwiftSyntaxMacros

enum LoggingShared {

    enum LogEvent {
        case entry
        case exit
        case assignment

        var symbol: String {
            switch self {
            case .entry:
                " ⮑ "
            case .exit:
                " ⮐ "
            case .assignment:
                " "
            }
        }
    }

    // MARK: - File name

    static func buildFileNameDecl(uniqueFileNameDeclIdentifier: TokenSyntax) -> VariableDeclSyntax {
        VariableDeclSyntax(
            bindingSpecifier: TokenSyntax(.keyword(.let), presence: .present),
            bindings: [
                PatternBindingSyntax(
                    pattern: IdentifierPatternSyntax(
                        identifier: uniqueFileNameDeclIdentifier
                    ),
                    initializer: InitializerClauseSyntax(
                        equal: TokenSyntax(.equal, presence: .present),
                        value: ForceUnwrapExprSyntax(
                            expression: MemberAccessExprSyntax(
                                base: FunctionCallExprSyntax(
                                    calledExpression: MemberAccessExprSyntax(
                                        base: MacroExpansionExprSyntax(
                                            pound: TokenSyntax(.pound, presence: .present),
                                            macroName: TokenSyntax(.identifier("file"), presence: .present),
                                            arguments: [],
                                            additionalTrailingClosures: []
                                        ),
                                        period: TokenSyntax(.period, presence: .present),
                                        declName: DeclReferenceExprSyntax(
                                            baseName: TokenSyntax(.identifier("split"), presence: .present)
                                        )
                                    ),
                                    leftParen: TokenSyntax(.leftParen, presence: .present),
                                    arguments: [
                                        LabeledExprSyntax(
                                            label: TokenSyntax(.identifier("separator"), presence: .present),
                                            colon: TokenSyntax(.colon, presence: .present),
                                            expression: StringLiteralExprSyntax(
                                                openingQuote: TokenSyntax(.stringQuote, presence: .present),
                                                segments: [
                                                    .stringSegment(
                                                        StringSegmentSyntax(
                                                            content: TokenSyntax(.stringSegment("/"), presence: .present)
                                                        )
                                                    )
                                                ],
                                                closingQuote: TokenSyntax(.stringQuote, presence: .present)
                                            )
                                        )
                                    ],
                                    rightParen: TokenSyntax(.rightParen, presence: .present),
                                    additionalTrailingClosures: []
                                ),
                                period: TokenSyntax(.period, presence: .present),
                                declName: DeclReferenceExprSyntax(
                                    baseName: TokenSyntax(.identifier("last"), presence: .present)
                                )
                            ),
                            exclamationMark: TokenSyntax(.exclamationMark, presence: .present)
                        )
                    )
                )
            ]
        )
    }

    // MARK: - Print

    static func buildPrintCallExpr(
        logEvent: LogEvent,
        uniqueFileNameDeclIdentifier: TokenSyntax
    ) -> FunctionCallExprSyntax {
        FunctionCallExprSyntax(
            calledExpression: DeclReferenceExprSyntax(
                baseName: TokenSyntax(.identifier("print"), presence: .present)
            ),
            leftParen: TokenSyntax(.leftParen, presence: .present),
            arguments: [
                LabeledExprSyntax(
                    expression: StringLiteralExprSyntax(
                        openingQuote: TokenSyntax(.stringQuote, presence: .present),
                        segments: StringLiteralSegmentListSyntax {
                            StringSegmentSyntax(
                                content: TokenSyntax(.stringSegment("["), presence: .present)
                            )
                            ExpressionSegmentSyntax(
                                backslash: TokenSyntax(.backslash, presence: .present),
                                leftParen: TokenSyntax(.leftParen, presence: .present),
                                expressions: [
                                    LabeledExprSyntax(
                                        expression: DeclReferenceExprSyntax(
                                            baseName: uniqueFileNameDeclIdentifier
                                        )
                                    )
                                ],
                                rightParen: TokenSyntax(.rightParen, presence: .present)
                            )
                            StringSegmentSyntax(
                                content: .stringSegment(":")
                            )
                            ExpressionSegmentSyntax(
                                backslash: .backslashToken(),
                                leftParen: .leftParenToken(),
                                expressions: [
                                    LabeledExprSyntax(
                                        expression: MacroExpansionExprSyntax(
                                            pound: .poundToken(),
                                            macroName: .identifier("line"),
                                            arguments: [],
                                            additionalTrailingClosures: []
                                        )
                                    )
                                ],
                                rightParen: .rightParenToken()
                            )
                            StringSegmentSyntax(
                                content: TokenSyntax(
                                    .stringSegment("]\(logEvent.symbol)"),
                                    presence: .present
                                )
                            )
                            ExpressionSegmentSyntax(
                                backslash: .backslashToken(),
                                leftParen: .leftParenToken(),
                                expressions: [
                                    LabeledExprSyntax(
                                        expression: MacroExpansionExprSyntax(
                                            pound: .poundToken(),
                                            macroName: .identifier("function"),
                                            arguments: [],
                                            additionalTrailingClosures: []
                                        )
                                    )
                                ],
                                rightParen: .rightParenToken()
                            )

                            if logEvent == .assignment {
                                StringSegmentSyntax(
                                    content: .stringSegment(" = ")
                                )
                                ExpressionSegmentSyntax(
                                    backslash: .backslashToken(),
                                    leftParen: .leftParenToken(),
                                    expressions: [
                                        LabeledExprSyntax(
                                            expression: DeclReferenceExprSyntax(
                                                baseName: .identifier("newValue")
                                            )
                                        )
                                    ],
                                    rightParen: .rightParenToken()
                                )
                            }
                            StringSegmentSyntax(
                                content: .stringSegment("")
                            )
                        },
                        closingQuote: TokenSyntax(.stringQuote, presence: .present)
                    )
                )
            ],
            rightParen: TokenSyntax(.rightParen, presence: .present),
            additionalTrailingClosures: []
        )
    }

}
