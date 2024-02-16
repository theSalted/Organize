//
//  StorageView.swift
//  Organize
//
//  Created by Yuhao Chen on 1/21/24.
//

import SwiftUI
import SwiftData

struct StorageView: View {
    @Environment(AppViewModel.self) private var appModel
    @Query private var storages: [Storage]
    
    var selectedStorages: [Storage] {
        storages.filter { appModel.storageListSelectionsIDs.contains($0.id) }
    }
    
    var title: String {
        switch selectedStorages.count {
        case 1:
            selectedStorages.first?.name ?? "Storage"
        case 2:
            "\(selectedStorages[0].name) and \(selectedStorages[1].name) Storages"
        case 3...:
            "\(selectedStorages[0].name) and \(selectedStorages.count - 1) More Storages"
        default:
            "Storage"
        }
    }

    var body: some View {
        VStack {
            switch selectedStorages.count {
            case 0:
                ContentUnavailableView(
                    "Select a Storage",
                    systemImage: "archivebox",
                    description: "Select one or multiple storages to get started.".inText)
            case 1: // Single Item selected
                SingleStorageDetailView(selectedStorages.first!).navigationTitle(title)
            case 2...: // Multiple Item selected
                ScrollView {
                    MetaGridView(selectedStorages).padding()
                }.navigationTitle(title)
            default:
                ContentUnavailableView(
                    "Something Went Wrong...",
                    systemImage: "exclamationmark.triangle",
                    description: "Number of selected storage is outside of possible range. Please contact support, we are sorry for your inconvenience.".inText)
            }
        }.scrollContentBackground(.hidden)
    }
}

#Preview {
    StorageView()
        .environment(AppViewModel())
}
