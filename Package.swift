// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Scaledrone",
    platforms: [
        .macOS(.v10_10),
        .iOS(.v9),
        .tvOS(.v9)
    ],
    products: [
        .library(
            name: "Scaledrone",
            targets: ["Scaledrone"]),
    ],
    dependencies: [
        .package(url: "https://github.com/daltoniam/Starscream.git", from: "3.1.1")
    ],
    targets: [
      .target(name: "Scaledrone",
              dependencies: [.product(name: "Starscream", package: "Starscream")]),
    ],
    swiftLanguageVersions: [.v5]
)
