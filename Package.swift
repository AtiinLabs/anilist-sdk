// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// The swift-docc-plugin dependency and the DocC Pages workflow were removed so
// apps that depend on this package (Ito) do not resolve a documentation-only
// package. Whether to bring the hosted DocC site back is decided after Ito's
// AniList migration; restoring it means re-adding
// `.package(url: "https://github.com/apple/swift-docc-plugin", from: "1.3.0")`
// and `.github/workflows/docc.yml` from git history.
let package = Package(
    name: "anilist",
    platforms: [
        .macOS(.v12), .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "anilist",
            targets: ["anilist"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "anilist"
        ),
        .testTarget(
            name: "anilistTests",
            dependencies: ["anilist"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
