// swift-tools-version:5.9
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
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.2")
    ],
    targets: [
        .target(
            name: "GoodExtensions",
            dependencies: ["GoodStructs"],
            path: "./Sources/GoodExtensions"
        ),
        .target(
             name: "GoodAsyncExtensions",
             dependencies: [
                 .product(name: "CombineExt", package: "CombineExt")
             ]
         ),
        .target(
            name: "GoodStructs",
            dependencies: [],
            path: "./Sources/GoodStructs"
        ),
        .target(
            name: "GoodMacros",
            dependencies: ["MacroCollection"],
            path: "./Sources/GoodMacros"
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
            ]
        ),
        .testTarget(
            name: "GoodStructsTests",
            dependencies: ["GoodStructs"]
        ),
        .testTarget(
            name: "GoodAsyncExtensionsTests",
            dependencies: ["GoodAsyncExtensions"]
        )
    ]
)
