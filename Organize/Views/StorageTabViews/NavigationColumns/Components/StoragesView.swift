//
//  StorageView.swift
//  Organize
//
//  Created by Yuhao Chen on 1/21/24.
//

import SwiftUI
import SwiftData

struct StoragesView: View {
    @Environment(\.modelContext) private var context
    @Environment(AppViewModel.self) private var appModel
    @Query private var storages: [Storage]
    
    @State private var showAddTitleAlert = false
    @State private var newItemName = ""
    @State private var searchText = ""
    @State private var isSearchPresented = false
    
    var selectedStorages: [Storage] {
        storages.filter { appModel.storageListSelections.contains($0.id) }
    }
    
    var itemsFromStorages: [Item] {
        selectedStorages.flatMap { storage in
            storage.items
        }
    }
    
    private var searchedItems : [Item] {
        if searchText.isEmpty {
            return itemsFromStorages
        } else {
            return itemsFromStorages.filter { $0.name?.contains(searchText) ?? false }
        }
    }
    
    var body: some View {
        VStack {
            List {
                GeometryReader { geometry in
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(storages) { storage in
                                MetaPrimitiveView(storage)
                                    .frame(idealWidth: geometry.size.width - 10,
                                           maxHeight: .infinity,
                                           alignment: .top)
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .scrollIndicators(.hidden)
                }
                .frame(height: 200, alignment: .center)
                Section(searchedItems.isEmpty ? "" : "Items") {
                    ForEach(searchedItems) { item in
                        NavigationLink(item.name ?? "Untitled") {
                            MetaInfoView(item)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
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
//        .adaptiveNavigationTitle(canRename: true, get: storage.name ?? "Untitled") { newTitle in
//            withAnimation {
//                storage.name = newTitle
//            }
//            try? context.save()
//        }
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
    
    private func addItem() {
        withAnimation {
            showAddTitleAlert = true
        }
    }
    
    private func createItem(_ name: String) {
        let item = Item(name: name)
        context.insert(item)
        try? context.save()
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                guard index < itemsFromStorages.count else { continue }
                context.delete(itemsFromStorages[index])
            }
        }
        try? context.save()
    }
}

#Preview {
    StoragesView()
}
