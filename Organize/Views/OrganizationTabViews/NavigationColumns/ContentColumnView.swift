//
//  ContentColumnView.swift
//  Organize
//
//  Created by Yuhao Chen on 1/24/24.
//

import SwiftUI
import SwiftData

struct ContentColumnView: View {
    // Environments and SwiftData Queries
    @Environment(\.modelContext) private var modelContext
    @Environment(AppViewModel.self) private var appModel
    @Query private var spaces: [Space]
    @Query private var storages: [Storage]
    
    // View States
    @State private var editMode: EditMode   = .inactive
    @State private var showCreateForm       = false
    @State private var searchText           = ""
    
    // Computed Properties
    var selectedSpaces: [Space] {
        spaces.filter { appModel.spaceListSelectionIDs.contains($0.id) }
    }
    private var storagesList: [Storage] {
        // TODO: Improve needed for the match algorithm in this computed property
        // -[ ] Better fuzzy match algorithm
        // -[ ] Implementation in generic of string extension
        return storages.filter { storage in
            guard let placement = storage.space else {
                return false
            }
            if searchText.isEmpty {
                return selectedSpaces.contains(placement)
            }
            return selectedSpaces.contains(placement) && storage.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    var title: String {
        if selectedSpaces.isEmpty {
            ""
        } else if selectedSpaces.count == 1 {
            selectedSpaces.first?.name ?? "Untitled"
        } else {
            "\(selectedSpaces.count) Selected Spaces"
        }
    }
    
    // Views
    var body: some View {
        @Bindable var appModel = appModel
        let count = appModel.spaceListSelectionIDs.count
        switch appModel.spaceListSelectionIDs.isEmpty {
        case false:
            List(selection: $appModel.storageListSelectionsIDs) {
                Section(
                    storagesList.isEmpty ? "" : "^[\(storagesList.count) Storages](inflect: true)"
                ) {
                    ForEach(storagesList) { storage in
                        Label {
                            Text(storage.name)
                        } icon: {
                            SymbolView(symbol: storage.symbol)
                                .foregroundStyle(storage.color)
                        }
                    }
                    .onDelete(perform: deleteStorages)
                }
            }
            .environment(\.editMode, $editMode)
            .searchable(text: $searchText)
            .adaptiveNavigationTitle(
                canRename: selectedSpaces.count == 1,
                get: title
            ) { newTitle in
                spaces.first?.name = newTitle
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(
                        "Edit Button",
                        systemImage: "checklist.unchecked"
                    ) { toggleEditMode() }
                        .symbolEffect(.bounce, value: editMode)
                        .symbolRenderingMode(.hierarchical)
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        addStorage()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .font(.title2)
                            .accessibilityLabel("Add storage")
                    }
                    .disabled(selectedSpaces.count > 1)
                    .symbolEffect(.bounce, value: showCreateForm)
                    .sensoryFeedback(.success, trigger: showCreateForm)
                }
            }
            .tint(selectedSpaces.first?.color ?? .accent)
            .overlay {
                // Placeholder View when space don't have any storage
                if storagesList.isEmpty {
                    if searchText.isEmpty {
                        ContentUnavailableView(
                            "Create a Storage",
                            systemImage: "archivebox",
                            description:
                                Text("The selected " +
                                     (count > 0 ? "spaces " : "space ") +
                                     "don't have any storage. Press the plus button to add one.")
                        )
                    } else {
                        ContentUnavailableView.search(text: searchText)
                    }
                }
            }
            .sheet(isPresented: $showCreateForm) {
                let space = selectedSpaces.first
                @State var storage = Storage(name: "My Storage")                
                
                FormEditView(
                    $storage, mode: .create,
                    unsafePlacementSelectionID: space?.id
                ) {
                    withAnimation {
                        showCreateForm = false
                    }
                } confirm: {
                    withAnimation {
                        showCreateForm = false
                        modelContext.insert(storage)
                    }
                    try? modelContext.save()
                }
            }
            
        default:
            ContentUnavailableView(
                "Select a Space",
                systemImage: "square.split.bottomrightquarter.fill",
                description: "Select or create your first space. And get organized.".inText)
        }
    }
    // Methods
    private func addStorage() {
        withAnimation {
            showCreateForm = true
        }
    }
    
    private func deleteStorages(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                guard index < storages.count else { continue }
                modelContext.delete(storages[index])
            }
        }
        try? modelContext.save()
    }
    
    private func toggleEditMode() {
        withAnimation {
            if editMode == .active {
                editMode = .inactive
            } else {
                editMode = .active
            }
        }
    }
}

#Preview {
    ContentColumnView()
        .environment(AppViewModel())
}
