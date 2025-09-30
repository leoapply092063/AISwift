// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "MiniVaporAI",
    platforms: [.macOS(.v13)],
    products: [.executable(name: "App", targets: ["App"])],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.92.0")
    ],
    targets: [
        .executableTarget(name: "App", dependencies: [.product(name: "Vapor", package: "vapor")])
    ]
)
