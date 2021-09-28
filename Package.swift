// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Effect",
    platforms: [
          .iOS(.v14),
          .macOS(.v11)
      ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Effect",
            targets: ["Effect"]),
    ],
    dependencies: [
        .package( url: "https://github.com/GeoffBurns/Utilities", from: "0.1.0"),
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Effect",
            dependencies: ["Utilities"],
            resources: [
                .process("Sound/fail_buzzer.mp3"),
                .process("Sound/magic_chime.mp3"),
                .process("Sound/shutter_click.mp3"),
                .process("Sound/sad_trombone.mp3"),
            ])
    ]
)
