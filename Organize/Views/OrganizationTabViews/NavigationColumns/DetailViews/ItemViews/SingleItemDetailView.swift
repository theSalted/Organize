//
//  SingleItemDetailView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/16/24.
//

import SwiftUI

struct SingleItemDetailView: View {
    var item: Item
    
    init(_ item: Item) {
        self.item = item
    }
    
    var body: some View {
        MetaInfoView(item)
    }
}

#Preview {
    SingleItemDetailView(Item(name: "My Item"))
}
