//
//  ColorSelectionGridView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/10/24.
//

import SwiftUI

struct ColorSelectionGridView: View {
    @Binding var color: Color
    
    let colorHeight: CGFloat = {
        if UIDevice.current.userInterfaceIdiom == .phone { 25 } 
        else { 35 }
    }()
    
    let verticalSpacing: CGFloat = {
        if UIDevice.current.userInterfaceIdiom == .phone { 20 }
        else { 30 }
    }()
    
    init(_ color: Binding<Color>) {
        self._color = color
    }
    
    var body: some View {
        VStack(spacing: verticalSpacing) {
            HStack {
                ForEach(ColorSelectionGridView.rowOneColors, id: \.self) { presetColor in
                    CircularColorSelectionView(presetColor, selection: $color)
                        .frame(maxWidth: .infinity)
                }
            }
            .allowsTightening(false)
            HStack {
                ForEach(ColorSelectionGridView.rowTwoColors, id: \.self) { presetColor in
                    CircularColorSelectionView(presetColor, selection: $color)
                        .frame(maxWidth: .infinity)
                }
                
                ColorPicker("Color", selection: $color)
                    .labelsHidden()
                    .frame(maxWidth: .infinity)
            }
            .allowsTightening(false)
        }
        .allowsTightening(false)
        .buttonStyle(PlainButtonStyle())
    }
}


/// Color Presets
extension ColorSelectionGridView {
    static let rowOneColors: [Color] = [.red, .orange, .yellow, .green, .cyan, .blue]
    static let rowTwoColors: [Color] = [.purple, .pink, .mint, .brown, .gray]
    static let presetColors: [Color] = rowOneColors + rowTwoColors
}


struct ColorSelectionGrid_Previews: PreviewProvider {
    static var previews: some View {
        @State var color: Color = .green
        @State var item: Item = Item(name: "My Item")
        ColorSelectionGridView($item.color)
    }
}
