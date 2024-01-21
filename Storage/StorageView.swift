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
    @State private var searchText = ""
    @State private var isSearchPresented = false
    
    private var searchedItems : [Item] {
        if searchText.isEmpty {
            return storage.items
        } else {
            return storage.items.filter { $0.name?.contains(searchText) ?? false }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                if !isSearchPresented {
                    StorageInfoView(storage)
                }
                
                Section(searchedItems.isEmpty ? "" : "Items") {
                    ForEach(searchedItems) { item in
                        NavigationLink(item.name ?? "Untitled") {
                            ItemView(item)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .overlay {
                // Placeholder View when storage don't have any items
                if searchedItems.isEmpty {
                    if searchText.isEmpty{
                        ContentUnavailableView("Let's Get Organized", systemImage: Item.randomSystemSymbol, description: Text("Select an item or create your first one."))
                    } else {
                        ContentUnavailableView.search(text: searchText)
                    }
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
            .navigationTitle(Binding(get: {
                storage.name ?? "Untitled"
            }, set: { newName in
                withAnimation {
                    storage.name = newName
                }
                try? context.save()
            }))
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
            .searchable(text: $searchText, isPresented: $isSearchPresented)
        }
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
