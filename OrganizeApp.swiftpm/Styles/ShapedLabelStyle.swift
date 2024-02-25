//
//  ShapedLabelStyle.swift
//  Organize
//
//  Created by Yuhao Chen on 2/7/24.
//

import SwiftUI

struct ShapedLabelStyle: LabelStyle {
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
        Label("Normal Label", systemImage: "circle")
        Label("Default ShapedLabel", systemImage: "circle")
            .labelStyle(ShapedLabelStyle())
        Label {
            Text("Colored CircledLabel")
        } icon: {
            Image(systemName: "cube")
                .foregroundStyle(.white)
        }
        .labelStyle(ShapedLabelStyle(backgroundColor: .red))
        
        Label {
            Text("Colored RoundedRectangleLabel")
        } icon: {
            Image(systemName: "cube")
                .foregroundStyle(.white)
        }
        .labelStyle(ShapedLabelStyle(shape: .roundedRectangle(8), backgroundColor: .mint))
        
        Label {
            Text("Different Ratio")
        } icon: {
            Image(systemName: "cube")
                .foregroundStyle(.white)
        }
        .labelStyle(ShapedLabelStyle(shape: .roundedRectangle(8), scaleEffect: 1, backgroundColor: .blue))
        
        Label {
            Text("Slightly Larger")
        } icon: {
            Image(systemName: "cube")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
        }
        .labelStyle(ShapedLabelStyle(shape: .roundedRectangle(8), backgroundColor: .orange))
        
        Label {
            Text("Icon Only")
        } icon: {
            Image(systemName: "cube")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.white)
                .frame(width: 100, height: 100)
        }
        .labelStyle(ShapedLabelStyle(shape: .roundedRectangle(8), backgroundColor: .purple))
        .labelStyle(IconOnlyLabelStyle())
    }
}
