// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Principle",
    platforms: [
        .macOS(.v13),
        .macCatalyst(.v16),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "Principle",
            targets: ["Principle"]
        )
    ],
    targets: [
        .target(
            name: "Principle"
        ),
        .testTarget(
            name: "PrincipleTests",
            dependencies: ["Principle"]
        )
    ]
)
