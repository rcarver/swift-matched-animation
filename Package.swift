// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-matched-animations",
    platforms: [
        .iOS(.v13),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "MatchedAnimation",
            targets: ["MatchedAnimation"]),
    ],
    targets: [
        .target(
            name: "MatchedAnimation",
            dependencies: []),
        .testTarget(
            name: "MatchedAnimationTests",
            dependencies: ["MatchedAnimation"]),
    ]
)
