// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Vexillum",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    products: [
        .library(name: "Vexillum", targets: ["Vexillum"]),
    ],
    targets: [
        .target(
            name: "Vexillum"),
        .testTarget(
            name: "VexillumTests",
            dependencies: ["Vexillum"]),
    ]
)
