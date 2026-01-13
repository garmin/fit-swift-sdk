// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "FITSwiftSDK",
    platforms: [
        .macOS(.v12),
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "FITSwiftSDK",
            targets: ["FITSwiftSDK"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-collections.git",
                .upToNextMinor(from: "1.2.0")
        )
    ],
    targets: [
        .target(
            name: "FITSwiftSDK",
            dependencies: [
                .product(name: "Collections", package: "swift-collections")
            ]
        ),
        .testTarget(
            name: "FITSwiftSDKTests",
            dependencies: ["FITSwiftSDK"],
            exclude: [
                "TestData/*.fit"
            ]
        ),
    ],
    swiftLanguageModes: [.v5, .v6]
)