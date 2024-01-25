//
//  ContentView.swift
//  Organize
//
//  Created by Yuhao Chen on 1/21/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State var appModel = AppViewModel()
    @State private var columnVisibility = NavigationSplitViewVisibility.all
    @Environment(\.verticalSizeClass) private var verticalSizeClass
//    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        TabView(selection: $appModel.tabViewSelection) {
            NavigationSplitView(columnVisibility: $columnVisibility) {
                SideBarView()
            } content: {
                ContentColumnView()
            } detail: {
                DetailsView()
            }
            .tabItem {
                Label("Organize", systemImage: "circle.grid.3x3.fill")
            }
            .tag(AppViewModel.TabViewTag.storage)
            .toolbar(verticalSizeClass == .compact ? .hidden : .automatic, for: .tabBar)
//            .toolbar(horizontalSizeClass != .compact ? .hidden : .automatic, for: .tabBar)
            
            CaptureView()
            .tabItem {
                Label("Scan", systemImage: "cube.fill")
            }
            .tag(AppViewModel.TabViewTag.scan)
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
