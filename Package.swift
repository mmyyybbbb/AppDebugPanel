// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "AppDebugPanel",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(name: "AppDebugPanel", targets: ["AppDebugPanel"])
    ],
    dependencies: [
        .package(url: "https://github.com/gbreen12/netfox", .upToNextMinor(from: "1.20.0"))
    ],
    
    targets: [
        .target(
            name: "AppDebugPanel",
            dependencies: ["NetFox"],
            path: "AppDebugPanel"
        )
    ]
)
