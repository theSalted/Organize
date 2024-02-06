//
//  ShapeLabelStyle+Design.swift
//  Organize
//
//  Created by Yuhao Chen on 2/7/24.
//

import SwiftUI


/// Implemented by ``ShapedLabelStyle``
private struct ShapeLabelStyleDesign: LabelStyle {
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
    
    var shape : Shape = .roundedRectangle(25)
    var scaleEffect: CGFloat = 0.7
    var backgroundColor : Color = Color(uiColor: .secondarySystemBackground)
    
    func makeBody(configuration: Configuration) -> some View {
        Label { configuration.title }
        icon: {
            ZStack {
                configuration.icon
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
        }
    }
}

#Preview {
    List {
        Label("Title 1", systemImage: "star")
        Label("Title 2", systemImage: "square")
        Label("Title 3", systemImage: "circle")
        Label(
            title: { Text("Title 4") },
            icon: { 
                Image(systemName: "42.circle")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.red)
                    .frame(width: 100, height: 100)
            }
        )
    }
    .labelStyle(ShapeLabelStyleDesign(shape: .roundedRectangle(7)))
}
