//
//  ItemView.swift
//  Storage
//
//  Created by Yuhao Chen on 1/22/24.
//

import SwiftUI

struct ItemView: View {
    @Bindable var item : Item
    init(_ item: Item) {
        self.item = item
    }
    var body: some View {
        VStack {
            GroupBox {
                ItemInfoView(item)
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle(item.name ?? "Untitled")
    }
}

#Preview {
    ItemView(Item(name: "Baseball"))
}
