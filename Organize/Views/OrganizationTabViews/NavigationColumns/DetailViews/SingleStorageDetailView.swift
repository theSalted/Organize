//
//  SingleStorageDetailView.swift
//  Organize
//
//  Created by Yuhao Chen on 1/31/24.
//

import SwiftUI
import SwiftData

struct SingleStorageDetailView: View {
    // Environments and SwiftData Queries
    @Environment(\.modelContext) private var modelContext
    @Environment(AppViewModel.self) private var appModel
    @Query private var storages: [Storage]
    
    // View States
    @State private var editMode: EditMode   = .inactive
    @State private var showCreateForm       = false
    @State private var searchText           = ""
    
    // Computed Properties
    var selectedStorages: [Storage] {
        storages.filter { appModel.storageListSelections.contains($0.id)}
    }
    var items: [Item] {
        selectedStorages.flatMap { storage in
            storage.items
        }
    }
    
    var meta : any Meta
    
    init(_ meta: any Meta) {
        self.meta = meta
    }
    
    var body: some View {
        @Bindable var appModel = appModel
        List(selection: $appModel.itemsListSelections) {
            CurtainStack(folds: 10) {
                MetaPrimitiveView(meta, title: "Information")
            } background: {
                Text("Hey! You found me")
            }
            .padding()
            ForEach(items) { item in
                Label {
                    Text(item.name)
                } icon: {
                    SymbolView(symbol: item.symbol)
                        .foregroundStyle(item.color)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit Button", systemImage: "checklist.unchecked") { toggleEditMode() }
                    .symbolEffect(.bounce, value: editMode)
                    .symbolRenderingMode(.hierarchical)
            }
            ToolbarItem(placement: .primaryAction) {
                Button {
                    addItem()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .font(.title2)
                        .accessibilityLabel("Add storage")
                }
                .disabled(selectedStorages.count > 1)
                .symbolEffect(.bounce, value: showCreateForm)
                .sensoryFeedback(.success, trigger: showCreateForm)
            }
        }
        .sheet(isPresented: $showCreateForm) {
            let storage = selectedStorages.first
            var item = Item(name: "My Item", at: storage)
            
            let target = Binding {
                item as (any Meta)
            } set: { newItemValue in
                item = newItemValue as! Item
            }
            
            FormEditView(target, mode: .create) {
                withAnimation {
                    showCreateForm = false
                }
            } confirm: {
                withAnimation {
                    showCreateForm = false
                }
                modelContext.insert(item)
                try? modelContext.save()
            }
        }
        .navigationTitle(meta.name)
        .scrollContentBackground(.hidden)
    }
    
    private func addItem() {
        withAnimation {
            showCreateForm = true
        }
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
    SingleStorageDetailView(Item(name: "Baseball"))
        .environment(AppViewModel())
}
