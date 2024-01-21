//
//  StorageInfoView.swift
//  Storage
//
//  Created by Yuhao Chen on 1/22/24.
//

import SwiftUI

struct StorageInfoView: View {
    var storage : Storage
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Information").font(.headline)
            Divider()
            VStack {
                if let storedAt = storage.space?.name {
                    InformationLabelView("Where", info: storedAt)
                }
            }
        }
    }
}

#Preview {
    StorageInfoView(storage: Storage(name: "Closet"))
}
