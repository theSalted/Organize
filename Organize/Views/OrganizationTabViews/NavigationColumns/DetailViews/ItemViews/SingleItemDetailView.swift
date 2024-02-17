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
        List {
            Section {
                MetaPrimitiveView(item, title: "Information")
            }
            
            if let previewImage = item.scan?.previewImage {
                Section {
                    Image(uiImage: previewImage)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
    }
}

#Preview {
    SingleItemDetailView(Item(name: "My Item"))
}
