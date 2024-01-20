//
//  StorageApp.swift
//  Storage
//
//  Created by Yuhao Chen on 1/21/24.
//

import SwiftUI
import SwiftData

@main
struct StorageApp: App {
    static let bundleId = "app.chenyuhao.storage"
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Space.self,
            Storage.self,
            Item.self
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
}
