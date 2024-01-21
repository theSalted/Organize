//
//  SpaceView.swift
//  Storage
//
//  Created by Yuhao Chen on 1/21/24.
//

import SwiftUI
import SwiftData

struct SpaceView: View {
    @Environment(\.modelContext) private var context
    @Bindable var space : Space
    @State private var showAddTitleAlert = false
    @State private var newStorageName = ""
    
    var body: some View {
        VStack {
            List {
                Section(space.storages.isEmpty ? "" : "Storage") {
                    ForEach(space.storages) { storage in
                        NavigationLink {
                            StorageView(storage: storage)
                        } label: {
                            Text(storage.name ?? "Untitled")
                        }
                    }
                    .onDelete(perform: deleteStorages)
                }
            }
        }
        .overlay {
            // Placeholder View when space don't have any storage
            if space.storages.isEmpty {
                ContentUnavailableView("Create a Storage", systemImage: "cabinet.fill", description: Text("Create your first storage for this space. Tap the plus button to get started."))
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    addStorage()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .font(.title2)
                        .accessibilityLabel("Add storage")
                }
            }
        }
        .alert("Add Storage", isPresented: $showAddTitleAlert) {
            TextField("Enter your Space Name", text: $newStorageName)
            Button("Cancel") {
                withAnimation {
                    showAddTitleAlert = false
                }
            }
            Button("Ok") {
                createStorage(newStorageName)
            }
        }
        .navigationTitle(Binding(get: {
            space.name ?? "Untitled"
        }, set: { newName in
            withAnimation {
                space.name = newName
            }
            try? context.save()
        }))
    }
    
    private func addStorage() {
        withAnimation {
            showAddTitleAlert = true
        }
    }
    
    private func createStorage(_ name: String) {
        let storage = Storage(name: name)
        context.insert(storage)
        withAnimation {
            space.storages.append(storage)
        }
        try? context.save()
    }
    
    private func deleteStorages(offsets: IndexSet) {
        withAnimation {
            space.storages.remove(atOffsets: offsets)
        }
        try? context.save()
    }
}

#Preview {
    SpaceView(space: Space(name: "Bedroom"))
}
