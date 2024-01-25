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
    @Environment(\.modelContext) private var context
    @Environment(AppViewModel.self) private var appModel
    @Query private var spaces: [Space]
    
    // View States
    @State private var editMode: EditMode   = .inactive
    @State private var showAddStorageFields = false
    @State private var newStorageName       = ""
    @State private var searchText           = ""
    
    // Computed Properties
    var selectedSpaces: [Space] {
        spaces.filter { appModel.spaceListSelections.contains($0.id) }
    }
    var storages: [Storage] {
        selectedSpaces.flatMap { space in
            space.storages
        }
    }
    var title: String {
        if selectedSpaces.isEmpty {
            ""
        } else if selectedSpaces.count == 1 {
            selectedSpaces.first?.name ?? "Untitled"
        } else {
            "\(selectedSpaces.count) Selected"
        }
    }
    
    // Views
    var body: some View {
        @Bindable var appModel = appModel
        let count = appModel.spaceListSelections.count
        switch appModel.spaceListSelections.isEmpty {
        case false:
            List(selection: $appModel.storageListSelections) {
                Section(storages.isEmpty ? "" : "^[\(storages.count) Storages](inflect: true)") {
                    ForEach(storages) { storage in
                        Text(storage.name ?? "Untitled")
                    }
                    .onDelete(perform: deleteStorages)
                }
            }
            .environment(\.editMode, $editMode)
            .searchable(text: $searchText)
            .adaptiveNavigationTitle(canRename: selectedSpaces.count == 1, get: title) { newTitle in
                spaces.first?.name = newTitle
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit Button", systemImage: "checklist.unchecked") { toggleEditMode() }
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
                    .symbolEffect(.bounce, value: showAddStorageFields)
                    .sensoryFeedback(.success, trigger: showAddStorageFields)
                }
            }
            .overlay {
                // Placeholder View when space don't have any storage
                if !searchText.isEmpty{
                    ContentUnavailableView.search(text: searchText)
                } else if storages.isEmpty {
                    ContentUnavailableView(
                        "Create a Storage",
                        systemImage: Item.randomSystemSymbol,
                        description:
                            Text("The selected " +
                                 (count > 0 ? "spaces " : "space ") +
                                 "don't have any storage. Press the plus button to add one.")
                    )
                }
            }
            .alert("Add Storage", isPresented: $showAddStorageFields) {
                TextField("Enter your Space Name", text: $newStorageName)
                Button("Cancel") {
                    withAnimation {
                        showAddStorageFields = false
                    }
                }
                Button("Ok") {
                    guard let space = selectedSpaces.first else {
                        return
                    }
                    createStorage(newStorageName, atSpace: space)
                }
            }
        default:
            ContentUnavailableView(
                "Select a Space",
                systemImage: "square.split.bottomrightquarter.fill",
                description: Text("Select or create your first space. And get organized."))
        }
    }
    // Methods
    private func addStorage() {
        withAnimation {
            showAddStorageFields = true
        }
    }
    
    private func createStorage(_ name: String, atSpace space: Space) {
        let storage = Storage(name: name)
        context.insert(storage)
        withAnimation {
            space.storages.append(storage)
        }
        try? context.save()
    }
    
    private func deleteStorages(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                guard index < storages.count else { continue }
                context.delete(storages[index])
            }
        }
        try? context.save()
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
