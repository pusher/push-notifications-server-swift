// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PushNotifications",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "PushNotifications",
            targets: ["PushNotifications"])
    ],
    dependencies: [
        // JWT support
        .package(url: "https://github.com/IBM-Swift/Swift-JWT.git",
                 .upToNextMajor(from: "3.1.1")),
        // Source code linting
        .package(url: "https://github.com/realm/SwiftLint",
                 .upToNextMajor(from: "0.43.1")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "PushNotifications",
            dependencies: ["SwiftJWT"]),
        .testTarget(
            name: "PushNotificationsTests",
            dependencies: ["PushNotifications"])
    ]
)
