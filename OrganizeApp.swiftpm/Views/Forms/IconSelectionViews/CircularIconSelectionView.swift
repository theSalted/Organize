//
//  CircleIconSelectionView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/11/24.
//

import SwiftUI

struct CircularIconSelectionView: View {
    typealias Symbol = String
    @Environment(\.colorScheme) var colorScheme
    
    let icon: Symbol
    let edgeSize: CGFloat = 35
    @Binding var selection: Symbol
    
    init(_ icon: Symbol, selection: Binding<Symbol>) {
        self.icon = icon
        self._selection = selection
    }
    
    var body: some View {
        Button {
            withAnimation { selection = icon }
        } label: {
            ZStack {
                Group {
                    if colorScheme == .light {
                        Circle().foregroundStyle(.gray.tertiary) }
                    else {
                        Circle().foregroundStyle(.gray.secondary) }
                }.frame(width: edgeSize, height: edgeSize)
                SymbolView(symbol: icon)
                    .tint(.primary)
                if icon == selection {
                    Circle()
                        .stroke(.ultraThinMaterial, lineWidth: 4)
                }
            }
            .frame(width: edgeSize * 1.3, height: edgeSize * 1.3)
        }
    }
}

#Preview {
    CircularIconSelectionView("cube.fill", selection: .constant("cube.fill"))
}
