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
    @State private var newObjectName = ""
    
    var body: some View {
        VStack {
            List {
                Section(space.storages.isEmpty ? "" : "Storage") {
                    ForEach(space.storages) { storage in
                        Text(storage.name ?? "Untitled")
                    }
                    .onDelete(perform: deleteObjects)
                }
            }
        }
        .overlay {
            // Placeholder View for when storages is empty
            if space.storages.isEmpty {
                ContentUnavailableView("Create a Storage", systemImage: "cabinet.fill", description: Text("Create your first storage for this space. Tap the plus button to get started."))
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAddTitleAlert = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .font(.title2)
                }
            }
        }
        .alert("Add Object", isPresented: $showAddTitleAlert) {
            TextField("Enter your Object Name", text: $newObjectName)
            Button("Cancel") {
                showAddTitleAlert = false
            }
            Button("Ok") {
                addObject(newObjectName)
            }
        }
        .navigationTitle(space.name ?? "Untitled")
    }
    
    private func addObject(_ name: String) {
        let object = Storage(name: name)
        context.insert(object)
        space.storages.append(object)
//        try? context.save()
    }
    
    private func deleteObjects(offsets: IndexSet) {
        withAnimation {
            space.storages.remove(atOffsets: offsets)
        }
//        try? context.save()
    }
}

#Preview {
    SpaceView(space: Space(name: "Bedroom"))
}
