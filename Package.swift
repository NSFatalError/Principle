// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Principle",
    platforms: [
        .macOS(.v15),
        .macCatalyst(.v18),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2)
    ],
    products: [
        .library(
            name: "Principle",
            targets: ["Principle"]
        ),
        .library(
            name: "PrincipleConcurrency",
            targets: ["PrincipleConcurrency"]
        ),
        .library(
            name: "PrincipleCollections",
            targets: ["PrincipleCollections"]
        )
    ],
    targets: [
        .target(
            name: "Principle",
            dependencies: [
                "PrincipleCollections",
                "PrincipleConcurrency"
            ]
        ),

        .target(
            name: "PrincipleConcurrency"
        ),
        .testTarget(
            name: "PrincipleConcurrencyTests",
            dependencies: ["PrincipleConcurrency"]
        ),

        .target(
            name: "PrincipleCollections"
        ),
        .testTarget(
            name: "PrincipleCollectionsTests",
            dependencies: ["PrincipleCollections"]
        )
    ]
)
