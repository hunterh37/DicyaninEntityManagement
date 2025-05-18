// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DicyaninEntityManagement",
    platforms: [
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "DicyaninEntityManagement",
            targets: ["DicyaninEntityManagement"]),
    ],
    dependencies: [
        .package(path: "../DicyaninEntity")
    ],
    targets: [
        .target(
            name: "DicyaninEntityManagement",
            dependencies: ["DicyaninEntity"]),
    ]
) 