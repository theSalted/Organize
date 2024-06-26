// swift-tools-version: 5.9

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "Organize",
    platforms: [
        .iOS("17.1")
    ],
    products: [
        .iOSApplication(
            name: "Organize",
            targets: ["AppModule"],
            bundleIdentifier: "app.yuhao.swift.student.challenge.24.organize",
            teamIdentifier: "52JMW2697M",
            displayVersion: "1.0",
            bundleVersion: "7",
            appIcon: .asset("AppIcon"),
            accentColor: .presetColor(.green),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ],
            capabilities: [
                .camera(purposeString: "Organize uses Camera for pictures and AR"),
                .locationWhenInUse(purposeString: "Organize uses location to help you find your spaces")
            ],
            appCategory: .utilities
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: ".",
            resources: [
                .process("Resources")
            ],
            swiftSettings: [
                .enableUpcomingFeature("BareSlashRegexLiterals")
            ]
        )
    ]
)
