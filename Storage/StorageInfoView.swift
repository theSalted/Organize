//
//  StorageInfoView.swift
//  Storage
//
//  Created by Yuhao Chen on 1/22/24.
//

import SwiftUI

struct StorageInfoView: View {
    var storage : Storage
    init(_ storage: Storage) {
        self.storage = storage
    }
    var body: some View {
        VStack(alignment: .leading) {
            Text("Information").font(.headline)
            Divider()
            VStack {
                if let storedAt = storage.space?.name {
                    InformationLabelView("Where", info: storedAt)
                }
                
                if let createdAt = storage.createdAt {
                    Divider()
                    InformationLabelView("Created", info: createdAt.formatted())
                }
                
            }
        }
    }
}

#Preview {
    StorageInfoView(Storage(name: "Closet"))
}
