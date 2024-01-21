//
//  ItemInfoView.swift
//  Storage
//
//  Created by Yuhao Chen on 1/22/24.
//

import SwiftUI

struct ItemInfoView: View {
    var item : Item
    
    init(_ item: Item) {
        self.item = item
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Information").font(.headline)
            Divider()
            VStack {
                if let storedAt = item.storage?.name {
                    InformationLabelView("Where", info: storedAt)
                }
                
                if let createdAt = item.createdAt {
                    Divider()
                    InformationLabelView("Created", info: createdAt.formatted())
                }
                
            }
        }
    }
}

#Preview {
    ItemInfoView(Item(name: "Baseball"))
}
