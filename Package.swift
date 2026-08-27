// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ArrayBuilder",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .watchOS(.v26),
        .tvOS(.v26),
        .visionOS(.v26)
    ],
    products: [
        .library(
            name: "ArrayBuilder",
            targets: [
                "ArrayBuilder"
            ]
        )
    ],
    targets: [
        .target(
            name: "ArrayBuilder"
        ),
        .testTarget(
            name: "ArrayBuilderTests",
            dependencies: [
                "ArrayBuilder"
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)
