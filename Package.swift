// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "AIWidget",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "AIWidgetApp", targets: ["AIWidget"]),
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "AIWidget",
            dependencies: ["Services", "Models"],
            path: "AIWidget/Sources/AIWidget"
        ),
        .target(
            name: "AIWidgetExtension",
            dependencies: ["Services", "Models"],
            path: "AIWidget/Sources/AIWidgetExtension"
        ),
        .target(
            name: "Services",
            path: "AIWidget/Sources/Services"
        ),
        .target(
            name: "Models",
            path: "AIWidget/Sources/Models"
        ),
    ]
)
