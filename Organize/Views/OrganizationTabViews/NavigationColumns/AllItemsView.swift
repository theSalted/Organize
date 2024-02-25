//
//  AllItemsView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/25/24.
//

import SwiftUI
import SwiftData

struct AllItemsView: View {
    @Query var items: [Item]
    
    var body: some View {
        List {
            Section("Bucket") {
                NavigationLink {
                    ItemsBucketView(items).ignoresSafeArea()
                } label: {
                    Label("Bucket", systemImage: "tray")
                }
            }
            
            Section("All Items") {
                ForEach(items) { item in
                    NavigationLink {
                        SingleItemDetailView(item)
                            .navigationTitle(item.name)
                    } label: {
                        Label {
                            Text(item.name)
                        } icon: {
                            SymbolView(symbol: item.symbol)
                                .foregroundStyle(item.color)
                        }
                    }

                }
            }
        }
        .navigationTitle("All Items")
    }
}

#Preview {
    AllItemsView()
}
