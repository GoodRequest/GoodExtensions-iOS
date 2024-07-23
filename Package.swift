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
            targets: ["GoodExtensions"]
        ),
        .library(
            name: "GoodAsyncExtensions",
            targets: ["GoodAsyncExtensions"]
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
        .package(url: "https://github.com/CombineCommunity/CombineExt.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-syntax.git", from: "600.0.0-latest")
    ],
    targets: [
        .target(
            name: "GoodExtensions",
            dependencies: ["GoodStructs"],
            path: "./Sources/GoodExtensions",
            swiftSettings: [.swiftLanguageVersion(.v6)]
        ),
        .target(
             name: "GoodAsyncExtensions",
             dependencies: [
                 .product(name: "CombineExt", package: "CombineExt")
             ],
             swiftSettings: [.swiftLanguageVersion(.v6)]
         ),
        .target(
            name: "GoodStructs",
            dependencies: [],
            path: "./Sources/GoodStructs",
            swiftSettings: [.swiftLanguageVersion(.v6)]
        ),
        .target(
            name: "GoodMacros",
            dependencies: ["MacroCollection"],
            path: "./Sources/GoodMacros",
            swiftSettings: [
                .swiftLanguageVersion(.v6),
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
            swiftSettings: [.swiftLanguageVersion(.v6)]
        ),
        .testTarget(
            name: "GoodStructsTests",
            dependencies: ["GoodStructs"],
            swiftSettings: [.swiftLanguageVersion(.v6)]
        ),
        .testTarget(
            name: "GoodAsyncExtensionsTests",
            dependencies: ["GoodAsyncExtensions"],
            swiftSettings: [.swiftLanguageVersion(.v6)]
        ),
        .testTarget(
            name: "GoodMacrosTests",
            dependencies: [
                "GoodMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ],
            swiftSettings: [
                .swiftLanguageVersion(.v6),
                .enableUpcomingFeature("BodyMacros"),
                .enableExperimentalFeature("BodyMacros")
            ]
        )
    ]
)
