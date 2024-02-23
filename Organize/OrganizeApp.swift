//
//  OrganizeApp.swift
//  Organize
//
//  Created by Yuhao Chen on 1/21/24.
//

import SwiftUI
import SwiftData
import TipKit

// TODO: MapKit
// TODO: SpriteKit
// TODO: Vision
// TODO: SwiftChart
// TODO: SceneKit
// TODO: Camera

@main
struct OrganizeApp: App {
    static let bundleId = "app.chenyuhao.organize"
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Space.self,
            Storage.self,
            Item.self,
            CapturedObject.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
    
    init() {
        configureTips()
    }
    
    private func configureTips() {
        try? Tips.configure()
        try? Tips.resetDatastore()
        Tips.showAllTipsForTesting()
    }
}
