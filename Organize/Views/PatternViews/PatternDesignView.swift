//
//  PatternView.swift
//  Organize
//
//  Created by Yuhao Chen on 1/27/24.
//

import SwiftUI
import Metal

struct PatternDesign {
    
}

struct PatternDesignView: View {
    let patternColor : Color
    let backgroundColor : Color
    
    init(patternColor: Color, backgroundColor: Color) {
        self.patternColor = patternColor
        self.backgroundColor = backgroundColor
    }
    
    init(patternColor : Color) {
        self.patternColor = patternColor
        self.backgroundColor = Color(uiColor: UIColor.systemBackground)
    }
    
    var body: some View {
        GeometryReader { geometry in
            TimelineView(.animation()) { timeline in
                let t = timeline.date.timeIntervalSinceReferenceDate
                ZStack {
                    PatternView(.fishScale, patternColor: patternColor, backgroundColor: backgroundColor, timeInterval: t, opacity: 0.3)
                    LinearGradient(
                        colors:
                            [backgroundColor,
                             backgroundColor.opacity(0.8),
                             .clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing)
                    AuroraView(
                        patternColor:
                            (Color.accentColor, Color.accentColor),
                        opacity: 0.15,
                        animationStyle: .dipFromTop,
                        shape: .fluffy,
                        blurMode: .halo,
                        timeline: timeline)
                }
            }
        }
    }
}

#Preview {
    PatternDesignView(patternColor: .accentColor)
        .ignoresSafeArea()
}
