//
//  MetaView.swift
//  Storage
//
//  Created by Yuhao Chen on 1/22/24.
//

import SwiftUI

struct MetaView: View {
    var meta : any Meta
    init(_ meta: any Meta) {
        self.meta = meta
    }
    var body: some View {
        VStack {
            GroupBox {
                MetaInfoView(meta)
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle(meta.name ?? "Untitled")
    }
}

#Preview {
    MetaView(Item(name: "Baseball"))
}
