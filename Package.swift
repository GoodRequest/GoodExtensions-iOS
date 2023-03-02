// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GoodExtensions",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "GoodExtensions",
            targets: ["GoodExtensions"]
        ),
        .library(
            name: "GoodStructs",
            targets: ["GoodStructs"]
        ),
        .library(
            name: "GoodCombineExtensions",
            targets: ["GoodCombineExtensions"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/CombineCommunity/CombineExt.git", from: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "GRCompatible",
            dependencies: []
        ),
        .target(
            name: "GoodExtensions",
            dependencies: [.target(name: "GRCompatible"), .target(name: "GoodStructs")]
        ),
        .target(
             name: "GoodCombineExtensions",
             dependencies: [
                 .product(name: "CombineExt", package: "CombineExt"),
                 .target(name: "GRCompatible")
             ]
         ),
        .target(
            name: "GoodStructs",
            dependencies: [],
            path: "./Sources/GoodStructs"
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
        )
    ]
)
