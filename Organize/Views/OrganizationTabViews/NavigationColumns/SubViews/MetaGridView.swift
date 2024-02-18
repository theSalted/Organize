//
//  MetaGridView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/17/24.
//

import SwiftUI

struct MetaGridView<T>: View where T: Meta{
    var targetsList: [T]
    let columns = [GridItem(.adaptive(minimum: 300, maximum: .infinity), spacing: 30)]
    
    init(_ targetsList: [T]) {
        self.targetsList = targetsList
    }
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(targetsList) { target in
                NavigationLink {
                    if let item = target as? Item {
                        SingleItemDetailView(item)
                            .navigationTitle(item.name)
                            .tint(item.color)
                    } else {
                        MetaInfoView(target)
                            .navigationTitle(target.name)
                    }
                } label: {
                    let color = target.color
                    VStack {
                        PatternDesignView(target.pattern, patternColor: color)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(LinearGradient(colors: [color, .clear, .clear], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                                     .brightness(1.1)
                            }
                            .overlay {
                                SymbolView(symbol: target.symbol)
                                    .font(.system(size: 60))
                                    .foregroundStyle(target.color.secondary)
                                    .shadow(color: .white.opacity(0.7), radius: 20)
                            }
                            .shadow(color: color.opacity(0.5), radius: 10)
                            .frame(maxWidth: .infinity, minHeight: 200)
                        Text(target.name)
                            .font(.headline)
                    }
                }
                .buttonStyle(.plain)
                .padding(.bottom)
            }
        }
    }
}

#Preview {
    MetaGridView([
        Item(name: "My Lovely Item One"),
        Item(name: "My Lovely Item Two")
    ])
}
