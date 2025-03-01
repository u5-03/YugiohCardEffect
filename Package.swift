// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "YugiohCardEffect",
    platforms: [.iOS(.v17), .macOS(.v15), .visionOS(.v2)],
    products: [
        .library(
            name: "YugiohCardEffect",
            targets: ["YugiohCardEffect"]),
    ],
    targets: [
        .target(
            name: "YugiohCardEffect"),

    ]
)
