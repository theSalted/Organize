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
        VStack(alignment: .leading) {
            Text("Information").font(.headline)
            
            VStack {
                if let name = meta.name {
                    Divider()
                    InformationLabelView("Name", info: name)
                }
                
                if let storedIn  = meta.storedIn {
                    Divider()
                    InformationLabelView("Where", info: storedIn)
                }
                
                if let createdAt = meta.createdAt {
                    Divider()
                    InformationLabelView("Created", info: createdAt.formatted())
                }
                
                Divider()
                InformationLabelView("Id", info: meta.id.uuidString)
            }
        }
    }
}

#Preview {
    MetaInfoView(Item(name: "Baseball"))
}
