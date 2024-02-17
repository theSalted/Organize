//
//  ItemView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/16/24.
//

import SwiftUI
import SwiftData

struct ItemView: View {
    @Environment(AppViewModel.self) private var appModel
    @Query private var storages: [Storage]
    @Query private var items: [Item]
    
    var selectedStorages: [Storage] {
        storages.filter { appModel.storageListSelectionsIDs.contains($0.id)}
    }
    var interpretedFromStoragesItemsList: [Item] {
        return items.filter { item in
            guard let placement = item.storage else {
                return false
            }
            return selectedStorages.contains(placement)
        }
    }
    var selectedItems: [Item] {
        items.filter { appModel.itemsListSelectionIDs.contains($0.id) }
    }
    var isMultipleStoragesSelected: Bool {
        return appModel.storageListSelectionsIDs.count > 1
    }
    var title: String {
        if isMultipleStoragesSelected {
            return "Items In Selected \(selectedStorages.count) Storages"
        }
        switch selectedItems.count {
        case 1:
            return selectedItems.first?.name ?? "Item"
        case 2:
            return "\(selectedItems[0].name) and \(selectedItems[1].name) Items"
        case 3...:
            return "\(selectedItems[0].name) and \(selectedItems.count - 1) More Items"
        default:
            return "Item"
        }
    }
    
    var body: some View {
        VStack {
            switch selectedItems.count {
            case 0:
                if isMultipleStoragesSelected {
                    if interpretedFromStoragesItemsList.count > 1 {
                        ScrollView {
                            MetaGridView(interpretedFromStoragesItemsList)
                                .padding()
                        }.navigationTitle(title)
                    } else {
                        ContentUnavailableView("No Items in Selected Storages", systemImage: "cube", description: "Create a item in one of your storage first".inText)
                    }
                } else {
                    ContentUnavailableView(
                        "Select an Item",
                        systemImage: "cube",
                        description: "Select one or more items to get started".inText)
                }
            case 1:
                let theSelectedItem = selectedItems.first!
                SingleItemDetailView(theSelectedItem)
                    .navigationTitle(title)
                    .tint(theSelectedItem.color)
            case 2...:
                ScrollView {
                    MetaGridView(selectedItems)
                        .padding()
                }
                .navigationTitle(title)
            default:
                ContentUnavailableView(
                    "Something Went Wrong...",
                    systemImage: "exclamationmark.triangle",
                    description: "Number of selected item is outside of possible range. Please contact support, we are sorry for your inconvenience.".inText)
            }
        }.scrollContentBackground(.hidden)
    }
}

#Preview {
    ItemView()
        .environment(AppViewModel())
}
