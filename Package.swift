// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Homeatic",
    dependencies: [
        // 💧 Web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/auth.git", from: "2.0.0-rc"),
        .package(url: "https://github.com/vapor/jwt.git", from: "3.0.0-rc"),
        .package(url: "https://github.com/vapor/fluent-sqlite.git", from: "3.0.0"),
        
        .package(url: "https://github.com/ReactiveX/RxSwift.git", "4.0.0" ..< "5.0.0"),
        .package(url: "https://github.com/JohnSundell/Files.git", from: "2.2.1")
    ],
    targets: [
        .target(name: "Library", dependencies: ["RxSwift", "Files"]),
        .target(name: "WebFront", dependencies: ["FluentSQLite", "Vapor", "RxSwift", "Authentication", "JWT"]),
        .target(name: "Run", dependencies: ["WebFront", "Library"]),
        .testTarget(name: "WebFrontTests", dependencies: ["WebFront"])
    ]
)

