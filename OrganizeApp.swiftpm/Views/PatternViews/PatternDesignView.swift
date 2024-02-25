//
//  PatternView.swift
//  Organize
//
//  Created by Yuhao Chen on 1/27/24.
//

import SwiftUI
import Metal

struct PatternDesignView: View, ShapeStyle {
    let design :          PatternDesign
    let patternColor :    Color
    let backgroundColor : Color
    
    init(_ design:        PatternDesign,
         patternColor:    Color,
         backgroundColor: Color) {
        self.design =          design
        self.patternColor =    patternColor
        self.backgroundColor = backgroundColor
    }
    init(_ design:      PatternDesign,
         patternColor : Color) {
        self.design =          design
        self.patternColor =    patternColor
        self.backgroundColor = Color(uiColor: UIColor.systemBackground)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                TimelineView(.animation()) { timeline in
                    let t = timeline.date.timeIntervalSinceReferenceDate
                    PatternView(
                        design.pattern,
                        patternColor: patternColor,
                        backgroundColor: backgroundColor,
                        timeInterval: t,
                        opacity: design.opacityStyle.patternOpacityValue(),
                        direction: design.patternAnimationDirection)
                }
                if let startPoint = design.gradientEffect.startingPoint,
                   let endPoint   = design.gradientEffect.endPoint,
                   design.gradientEffect != .noGradient {
                    LinearGradient(
                        colors:
                            [backgroundColor,
                             backgroundColor.opacity(0.8),
                             .clear],
                        startPoint: startPoint,
                        endPoint: endPoint)
                }
                AuroraView(
                    patternColor:
                        (patternColor, patternColor),
                    opacity: design.opacityStyle.auroraOpacityValue(),
                    animationStyle: design.auroraAnimationStyle,
                    shape: design.auroraShape,
                    blurMode: design.auroraBlurStyle)
            }
        }
    }
}

#Preview {
    PatternDesignView(PatternDesign.getRandomDesign(gradientEffect: .topLeadingToBottomTrailing) ,
        patternColor: .accentColor,
        backgroundColor: Color(uiColor: UIColor.secondarySystemBackground))
        .ignoresSafeArea()
}
