//
//  MetaInfoView.swift
//  Storage
//
//  Created by Yuhao Chen on 1/22/24.
//

import SwiftUI

struct MetaInfoView: View {
    var meta : any Meta
    init(_ meta: any Meta) {
        self.meta = meta
    }
    var body: some View {
        VStack {
            GroupBox {
                MetaPrimitiveView(meta, title: "Information")
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle(meta.name)
    }
}

#Preview {
    MetaInfoView(Item(name: "Baseball"))
}
