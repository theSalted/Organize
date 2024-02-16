//
//  DetailsView.swift
//  Organize
//
//  Created by Yuhao Chen on 1/25/24.
//

import SwiftUI
import SwiftData

struct DetailsView: View {
    // Environments and SwiftData Queries
    @Environment(\.modelContext) private var context
    @Environment(AppViewModel.self) private var appModel
    @Query private var spaces: [Space]
    
    // View States
    @State private var editMode: EditMode    = .inactive
    @State private var showAddStorageFields  = false
    @State private var newStorageName        = ""
    @State private var searchText            = ""
    
    // Computed Properties
    var selectedSpaces: [Space] {
        spaces.filter { appModel.spaceListSelections.contains($0.id) }
    }
    var storages: [Storage] {
        selectedSpaces.flatMap { space in
            space.storages
        }
    }
    
    init() {
        // TODO: SwiftUI bug Pageindicator TabView page style lightmode workaround
        // PageIndicator of TabViewStyle don't adopt to lightmode for some reason
        // manual implementation for lightmode
        // For currentPageIndicatorTintiColor I choose .label, but .tint also works
        // -[ ] Consider reproduce and file a bug report to Apple
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.label
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.secondaryLabel
    }
    
    var body: some View {
        @Bindable var appModel = appModel
        NavigationStack {
            switch appModel.spaceListSelections.isEmpty {
            case false:
                TabView {
                    // Item Selection Detail
                    if !appModel.itemsListSelections.isEmpty {
                        ItemView()
                            .tabItem {
                                Label("Item", systemImage: "cube")
                            }
                    }
                    // Storage Selection Detail
                    if !appModel.storageListSelections.isEmpty {
                        StorageView()
                            .tabItem {
                                Label("Storage", systemImage: "archivebox")
                            }
                    }
                    // Space Selection Detail
                    SpaceView()
                    .tabItem { Label("Space", systemImage: "square.split.bottomrightquarter") }
                    
                }
                .navigationBarTitleDisplayMode(.large)
                .tabViewStyle(.page)
            default:
                ContentUnavailableView(
                    "Let's Get Organized",
                    systemImage: "soccerball",
                    description: "Select an item or create your first one.".inText)
            }
        }
    }
}

#Preview {
    DetailsView()
        .environment(AppViewModel())
}
