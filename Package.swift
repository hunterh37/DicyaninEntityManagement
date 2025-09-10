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
        .package(url: "https://github.com/hunterh37/DicyaninEntity.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "DicyaninEntityManagement",
            dependencies: ["DicyaninEntity"]),
    ]
) 
