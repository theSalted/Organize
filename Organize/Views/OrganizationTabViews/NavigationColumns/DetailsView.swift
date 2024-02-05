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
    var body: some View {
        @Bindable var appModel = appModel
        NavigationStack {
            switch appModel.spaceListSelections.isEmpty {
            case false:
                TabView {
                    if !appModel.storageListSelections.isEmpty {
                        StorageView()
                            .tabItem { Label("Storage", systemImage: "archivebox") }
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