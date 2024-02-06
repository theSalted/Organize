//
//  ShapeIconView+Design.swift
//  Organize
//
//  Created by Yuhao Chen on 2/7/24.
//

import SwiftUI

/// Implemented by ``ShapedLabelStyle``
struct ShapeIconView_Design: View {
    enum Shape {
        case circle, roundedRectangle(_ cornerRadius: CGFloat)
        
        var cornerRadius : CGFloat {
            switch self {
            case .circle:
                return .infinity
            case .roundedRectangle(let radius):
                return radius
            }
        }
    }
    var shape: Shape = .roundedRectangle(25)
    var scaleEffect: CGFloat = 0.7
    var backgroundColor : Color = Color(uiColor: .secondarySystemBackground)
    
    var body: some View {
        icon
            .scaleEffect(scaleEffect)
            .background {
                switch shape {
                case .circle:
                    Circle()
                        .foregroundStyle(backgroundColor)
                case .roundedRectangle:
                    RoundedRectangle(cornerRadius: shape.cornerRadius)
                        .foregroundStyle(backgroundColor)
                }
            }
        
    }
    
    var icon: some View {
        
        Image(systemName: "42.circle")
    }
}

#Preview {
    ShapeIconView_Design()
}
