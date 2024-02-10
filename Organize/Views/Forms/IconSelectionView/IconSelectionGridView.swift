//
//  IconSelectionGridView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/11/24.
//

import SwiftUI

struct IconSelectionGridView: View {
    typealias Icon = String
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @Binding var icon: Icon
    let presetIcons: [Icon]
    
    init(_ icon: Binding<Icon>, presetIcons: [Icon]) {
        self._icon = icon
        self.presetIcons = presetIcons
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(presetIcons, id: \.self) { presetIcon in
                CircularIconSelectionView(presetIcon, selection: $icon)
                .frame(maxWidth: .infinity)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    IconSelectionGridView(.constant("cube.fill"), presetIcons: Item.symbolList)
}
