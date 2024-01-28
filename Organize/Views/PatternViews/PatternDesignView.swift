//
//  PatternView.swift
//  Organize
//
//  Created by Yuhao Chen on 1/27/24.
//

import SwiftUI
import Metal

struct PatternDesignView: View {
    let design : PatternDesign
    let patternColor : Color
    let backgroundColor : Color
    
    init(_ design: PatternDesign,
         patternColor: Color,
         backgroundColor: Color) {
        self.design = design
        self.patternColor = patternColor
        self.backgroundColor = backgroundColor
    }
    
    init(_ design: PatternDesign,patternColor : Color) {
        self.design = design
        self.patternColor = patternColor
        self.backgroundColor = Color(uiColor: UIColor.systemBackground)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                TimelineView(.animation()) { timeline in
                    let t = timeline.date.timeIntervalSinceReferenceDate
                    ZStack {
                        PatternView(
                            design.pattern,
                            patternColor: patternColor,
                            backgroundColor: backgroundColor,
                            timeInterval: t,
                            opacity: design.opacityStyle.patternOpacityValue(),
                            direction: design.patternAnimationDirection)
                        LinearGradient(
                            colors:
                                [backgroundColor,
                                 backgroundColor.opacity(0.8),
                                 .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing)
                    }

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
    PatternDesignView(PatternDesign.getRandomDesign() ,
        patternColor: .accent,
        backgroundColor: Color(uiColor: UIColor.secondarySystemBackground))
        .ignoresSafeArea()
}
