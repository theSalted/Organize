//
//  MetaPrimitiveView.swift
//  Storage
//
//  Created by Yuhao Chen on 1/22/24.
//

import SwiftUI

struct MetaPrimitiveView: View {
    var meta : any Meta
    var title : String
    init(_ meta: any Meta, title: String) {
        self.meta = meta
        self.title = title
    }
    
    init(_ meta: any Meta) {
        self.meta = meta
        self.title = meta.name
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title).font(.headline)
            
            VStack {
                Divider()
                InformationLabelView("Name", info: meta.name)
                
                if let storedIn  = meta.storedIn {
                    Divider()
                    InformationLabelView("Where", info: storedIn)
                }
                
                Divider()
                InformationLabelView("Created", info: meta.createdAt.formatted())
                
                Divider()
                InformationLabelView("Id", info: meta.id.uuidString)
            }
        }
    }
}

#Preview {
    MetaPrimitiveView(Item(name: "Baseball"))
}
