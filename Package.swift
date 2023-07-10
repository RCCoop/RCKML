// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RCKML",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .watchOS(.v6),
        .tvOS(.v14)
    ],
    products: [
        .library(
            name: "RCKML",
            targets: ["RCKML"]),
    ],
    dependencies: [
        .package(url: "https://github.com/tadija/AEXML.git", from:"4.6.0"),
        .package(url: "https://github.com/weichsel/ZIPFoundation.git", .upToNextMajor(from: "0.9.0"))
    ],
    targets: [
        .target(
            name: "RCKML",
            dependencies: ["AEXML", "ZIPFoundation"]),
        .testTarget(
            name: "RCKMLTests",
            dependencies: ["RCKML", "AEXML", "ZIPFoundation"],
            resources: [.process("GoogleTest.kml"), .process("GoogleTest.json")]
        ),
    ]
)
