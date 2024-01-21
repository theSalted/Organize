//
//  ContentView.swift
//  Storage
//
//  Created by Yuhao Chen on 1/21/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var columnVisibility = NavigationSplitViewVisibility.all
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            SpaceListView()
        } content: {
            ContentUnavailableView("Select a Space", systemImage: "square.split.bottomrightquarter.fill", description: Text("Select or create your first space. And get organized."))
        } detail: {
            // Placeholder when no space is selected
            ContentUnavailableView("Let's Get Organized", systemImage: Item.randomSystemSymbol, description: Text("Select an item or create your first one."))
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Space.self, inMemory: true)
}
