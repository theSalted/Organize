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
        ScrollView {
            CurtainStack(folds: 10) {
                GroupBox {
                    MetaPrimitiveView(meta, title: "Information")
                }
            } background: {
                Text("Shit")
            }
            .padding()
        }
        .navigationTitle(meta.name)
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    MetaInfoView(Item(name: "Baseball"))
}
