//
//  CurtainEffect.swift
//  Organize
//
//  Created by Yuhao Chen on 1/30/24.
//

import SwiftUI

struct CurtainEffect: ViewModifier, Animatable {
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get {
            AnimatableData(dragPosition.x, dragPosition.y)
        }
        set {
            dragPosition.x = newValue.first
            dragPosition.y = newValue.second
        }
    }

    /// The location of the drag in the coordinate space of `content`.
    var dragPosition: CGPoint

    var maxX: CGFloat

    var foldCount: Int

    /// See Curtain.metal
    let shaderFunction = ShaderFunction(library: .default, name: "curtain")

    init(foldCount: Int = 4, dragPosition: CGPoint, maxX: CGFloat) {
        self.foldCount = foldCount
        self.dragPosition = dragPosition
        self.maxX = maxX
    }

    func body(content: Content) -> some View {
        let shader = Shader(function: shaderFunction, arguments: [
            .boundingRect,
            .float2(max(20, animatableData.first), animatableData.second),
            .float(Float(foldCount))
        ])

        let isEnabled = dragPosition.x != maxX

        content

            .visualEffect { content, geometryProxy in
                content
                    .layerEffect(
                        shader,
                        maxSampleOffset: CGSize(width: geometryProxy.size.width, height: 20),
                        isEnabled: isEnabled
                    )
            }
    }
}
