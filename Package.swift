// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "GoodExtensions",
    platforms: [
        .macOS(.v12),
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "GoodExtensions",
            targets: ["GoodExtensions", "GoodStructs", "GoodMacros"]
        ),
        .library(
            name: "GoodStructs",
            targets: ["GoodStructs"]
        ),
        .library(
            name: "GoodMacros",
            targets: ["GoodMacros"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", "600.0.0" ..< "603.0.0")
    ],
    targets: [
        .target(
            name: "GoodExtensions",
            dependencies: ["GoodStructs"],
            path: "./Sources/GoodExtensions",
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .target(
            name: "GoodStructs",
            dependencies: [],
            path: "./Sources/GoodStructs",
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .target(
            name: "GoodMacros",
            dependencies: ["MacroCollection"],
            path: "./Sources/GoodMacros",
            swiftSettings: [
                .swiftLanguageMode(.v6),
                .enableUpcomingFeature("BodyMacros"),
                .enableExperimentalFeature("BodyMacros")
            ]
        ),
        .macro(
            name: "MacroCollection",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ],
            path: "./Sources/MacroCollection"
        ),
        .testTarget(
            name: "GoodExtensionsTests",
            dependencies: ["GoodExtensions"],
            resources:
            [
                .copy("Resources/EmptyElement.json"),
                .copy("Resources/ArrayNil.json")
            ],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .testTarget(
            name: "GoodStructsTests",
            dependencies: ["GoodStructs"],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .testTarget(
            name: "GoodMacrosTests",
            dependencies: [
                "GoodMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ],
            swiftSettings: [
                .swiftLanguageMode(.v6),
                .enableUpcomingFeature("BodyMacros"),
                .enableExperimentalFeature("BodyMacros")
            ]
        )
    ]
)
