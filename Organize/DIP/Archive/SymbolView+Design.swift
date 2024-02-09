//
//  Skeleton.swift
//  Organize
//
//  Created by Yuhao Chen on 2/8/24.
//

import SwiftUI

/// Implemented by ``SymbolView``
private struct Skeleton: View {
    var symbol : String
    var body: some View {
        Group {
            if symbol.isSingleEmoji {
                Text(symbol)
            } else {
                Image(systemName: symbol)
            }
        }
    }
}

#Preview {
    VStack {
        Skeleton(symbol: "circle")
            .font(.largeTitle)
        Skeleton(symbol: "🫠")
            .font(.largeTitle)
    }
}
