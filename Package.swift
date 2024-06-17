// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Nextbike",
    platforms: [
        .macOS(.v10_15), .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "Nextbike",
            targets: ["Nextbike"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(
            url: "https://github.com/Flight-School/AnyCodable",
            from: "0.6.0"
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Nextbike",
            dependencies: ["AnyCodable"]),
        .testTarget(
            name: "NextbikeTests",
            dependencies: ["Nextbike"]),
    ]
)
