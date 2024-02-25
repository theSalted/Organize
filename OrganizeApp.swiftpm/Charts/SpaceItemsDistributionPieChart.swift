//
//  SpaceStorageDistributionPieChart.swift
//  Organize
//
//  Created by Yuhao Chen on 2/25/24.
//

import SwiftUI
import Charts

struct SpaceItemsDistributionPieChart: View {
    var space: Space
    var body: some View {
        let storages = space.storages
        let items = storages.flatMap { storage in
            storage.items
        }
        if !(storages.isEmpty || items.isEmpty) {
            VStack {
                Chart(storages) { storage in
                    SectorMark(angle: .value(storage.name, storage.items.count))
                        .foregroundStyle(storage.color)
                        .symbol {
                            SymbolView(symbol: space.symbol)
                        }
                }
                .chartLegend(.visible)
                Text("Items distribution")
                    .font(.caption)
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        } else {
            EmptyView()
        }
    }
}

