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
    dependencies: [
        .package(
            url: "https://github.com/swiftlang/swift-docc-plugin.git",
            exact: "1.5.0"
        ),
        .package(
            url: "https://github.com/nicklockwood/SwiftFormat.git",
            exact: "0.61.1"
        )
    ],
    targets: [
        .target(
            name: "ArrayBuilder",
            swiftSettings: [
                .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
                .enableUpcomingFeature("ExistentialAny"),
                .enableUpcomingFeature("MemberImportVisibility")
            ]
        ),
        .testTarget(
            name: "ArrayBuilderTests",
            dependencies: [
                "ArrayBuilder"
            ],
            swiftSettings: [
                .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
                .enableUpcomingFeature("ExistentialAny"),
                .enableUpcomingFeature("MemberImportVisibility")
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)
