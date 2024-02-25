//
//  IconNameCardView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/10/24.
//

import SwiftUI
import CoreML

struct IconNameCardView: View {
    enum Mode {
        case edit, display
    }
    
    @Binding var name: String
    var color: Color
    var pattern: PatternDesign
    var symbol: String
    var mode: Mode = .edit
    
    init(name: Binding<String>,
         mode: Mode = .edit,
         color: Color,
         pattern: PatternDesign,
         symbol: String
    ) {
        self._name = name
        self.mode = mode
        self.color = color
        self.pattern = pattern
        self.symbol = symbol
    }
    
    init(
        _ target: any Meta,
        mode: Mode = .edit
    ) {
        self._name = Binding {
            target.name
        } set: { newValue in
            target.name = newValue
        }
        self.mode = mode
        self.color = target.color
        self.pattern = target.pattern
        self.symbol = target.symbol
    }
    
    var body: some View {
        ZStack {
            patternBackgroundCard
            iconAndName.padding()
        }
        .listRowSpacing(0)
        .listRowInsets(.init())
    }
    
    var iconAndName: some View {
        VStack(spacing: 15) {
            icon.shadow(color: color, radius: 20)
            switch mode {
            case .edit:
                TextField("Name", text: $name)
                    .textFieldStyle(.roundedBorder)
            case .display:
                Text(name)
                    .font(.headline)
                    .foregroundStyle(.primary)
            }
        }

    }
    
    var patternBackgroundCard: some View {
        ZStack {
            PatternDesignView(pattern, patternColor: color)
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.4), lineWidth: 2)
        }
    }
    
    var icon: some View {
        ZStack {
            Circle().foregroundStyle(color.gradient)
            SymbolView(symbol: symbol)
                .font(.custom("LargeIcon", size: 45))
                .foregroundStyle(.white)
        }
        .frame(height: 90)
    }
}

struct IconNameCard_Previews: PreviewProvider {
    static var previews: some View {
        @State var item = Item(name: "My Item", symbol: "🥺")
        IconNameCardView(name: $item.name, color: item.color, pattern: item.pattern, symbol: item.symbol)
            .frame(height: 200)
            .padding()
        IconNameCardView(Item(name: "MyItem"))
    }
}
