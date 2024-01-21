//
//  ContentView.swift
//  Storage
//
//  Created by Yuhao Chen on 1/21/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State var appModel = AppDataModel()
    @State private var columnVisibility = NavigationSplitViewVisibility.all
    @Environment(\.verticalSizeClass) private var verticalSizeClass
//    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        TabView(selection: $appModel.tabViewSelection) {
            NavigationSplitView(columnVisibility: $columnVisibility) {
                SpaceListView()
            } content: {
                ContentUnavailableView("Select a Space", systemImage: "square.split.bottomrightquarter.fill", description: Text("Select or create your first space. And get organized."))
            } detail: {
                // Placeholder when no space is selected
                ContentUnavailableView("Let's Get Organized", systemImage: Item.randomSystemSymbol, description: Text("Select an item or create your first one."))
            }
            .tabItem {
                Label("Storage", systemImage: "circle.grid.3x3.fill")
            }
            .tag(AppDataModel.TabViewTag.storage.rawValue)
            .toolbar(verticalSizeClass == .compact ? .hidden : .automatic, for: .tabBar)
//            .toolbar(horizontalSizeClass != .compact ? .hidden : .automatic, for: .tabBar)
            
            CaptureView()
            .tabItem {
                Label("Scan", systemImage: "cube.fill")
            }
            .tag(AppDataModel.TabViewTag.scan.rawValue)
            .toolbar(verticalSizeClass == .compact ? .hidden : .automatic, for: .tabBar)
//            .toolbar(horizontalSizeClass != .compact ? .hidden : .automatic, for: .tabBar)
        }
        .environment(appModel)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Space.self, inMemory: true)
}
