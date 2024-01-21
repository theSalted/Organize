//
//  StorageView.swift
//  Storage
//
//  Created by Yuhao Chen on 1/21/24.
//

import SwiftUI

struct StorageView: View {
    @Environment(\.modelContext) private var context
    @Bindable var storage: Storage
    @State private var showAddTitleAlert = false
    @State private var newItemName = ""
    
    var body: some View {
        VStack {
            List {
                VStack(alignment: .leading) {
                    Text("Information").font(.headline)
                    Divider()
                    VStack {
                        if let storedAt = storage.space?.name {
                            HStack {
                                Text("Where")
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text(storedAt)
                            }
                            .font(.caption)
                            .padding(.vertical, 2)
                        }
                    }
                }
                
                Section(storage.items.isEmpty ? "" : "Items") {
                    ForEach(storage.items) { item in
                        Text(item.name ?? "Untitled")
                    }
                    .onDelete(perform: deleteItems)
                }
            }
        }
        .overlay {
            // Placeholder View when storage don't have any items
            if storage.items.isEmpty {
                ContentUnavailableView("Let's Get Organized", systemImage: Item.randomSystemSymbol, description: Text("Select an item or create your first one."))
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    addItem()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .font(.title2)
                        .accessibilityLabel("Add item")
                }
            }
        }
        .alert("Add Item", isPresented: $showAddTitleAlert) {
            TextField("Enter your Space Name", text: $newItemName)
            Button("Cancel") {
                withAnimation {
                    showAddTitleAlert = false
                }
            }
            Button("Ok") {
                createItem(newItemName)
            }
        }
        .navigationTitle(Binding(get: {
            storage.name ?? "Untitled"
        }, set: { newName in
            withAnimation {
                storage.name = newName
            }
            try? context.save()
        }))
    }
    
    private func addItem() {
        withAnimation {
            showAddTitleAlert = true
        }
    }
    
    private func createItem(_ name: String) {
        let item = Item(name: name)
        context.insert(item)
        withAnimation {
            storage.items.append(item)
        }
        try? context.save()
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            storage.items.remove(atOffsets: offsets)
        }
        try? context.save()
    }
}

#Preview {
    StorageView(storage: Storage(name: "Soccer Ball"))
}
