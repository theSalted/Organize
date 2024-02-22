//
//  StorageListView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/23/24.
//

import SwiftUI

// TODO: Unfinished View
struct StorageListView: View {
    var storages: [Storage]
    var body: some View {
        if storages.isEmpty {
            ContentUnavailableView(
                "No Storage",
                systemImage: "archivebox")
        } else {
            List(storages) { storage in
                NavigationLink(storage.name) {
                    SingleStorageDetailView(storage)
                }
            }
        }
    }
}

#Preview {
    StorageListView(storages: [])
}
