//
//  SymbolView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/10/24.
//

import SwiftUI

struct SymbolView: View {
    var symbol : String
    var body: some View {
        Group {
            if symbol.isSingleEmoji {
                Text(symbol)
                    .transition(.scale)
            } else {
                Image(systemName: symbol)
                    .transition(.scale)
            }
        }
    }
}

#Preview {
    VStack {
        SymbolView(symbol: "circle")
            .font(.largeTitle)
        SymbolView(symbol: "🫠")
            .font(.largeTitle)
    }
}

