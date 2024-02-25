//
//  CircularColorSelectionView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/10/24.
//

import SwiftUI

struct CircularColorSelectionView: View {
    let color: Color
    @Binding var selectionColor: Color
    
    init(_ color: Color, selection selectionColor: Binding<Color>) {
        self.color = color
        self._selectionColor = selectionColor
    }
    
    let edgeSize: CGFloat = {
        if UIDevice.current.userInterfaceIdiom == .phone { 25 }
        else { 32 }
    }()
    
    var body: some View {
        Button {
            withAnimation {
                selectionColor = color
            }
        } label: {
            ZStack {
                Circle()
                    .foregroundStyle(color.gradient)
                    .frame(width: edgeSize, height: edgeSize)
                if ColorComponents.fromColor(color) == ColorComponents.fromColor(selectionColor) {
                    Circle()
                        .stroke(.ultraThinMaterial, lineWidth: 4)
                }
            }
            .frame(width: edgeSize * 1.4, height: edgeSize * 1.4)
        }
    }
}

#Preview {
    CircularColorSelectionView(.green, selection: .constant(.gray))
}
