//
//  CircularEmojiSelectionView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/11/24.
//

import SwiftUI

struct CircularEmojiSelectionView: View {
    typealias Emoji = String
    @Environment(\.colorScheme) var colorScheme
    
    let icon: Emoji
    let edgeSize: CGFloat = 35
    @Binding var selection: Emoji
    
    init(_ icon: Emoji, selection: Binding<Emoji>) {
        self.icon = icon
        self._selection = selection
    }
    
    var body: some View {
        Button {
            withAnimation { selection = icon }
        } label: {
            ZStack {
                Circle()
                    .foregroundStyle(.accent.tertiary)
                    .frame(width: edgeSize, height: edgeSize)
                SymbolView(symbol: icon)
                    .foregroundStyle(.accent)
                if selection.isSingleEmoji {
                    Circle()
                        .stroke(.accent.tertiary, lineWidth: 4)
                }
            }
            .frame(width: edgeSize * 1.3, height: edgeSize * 1.3)
        }
    }
}

#Preview {
    CircularEmojiSelectionView("eyes", selection: .constant("🥹"))
}
