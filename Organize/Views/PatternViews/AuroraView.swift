//
//  AuroraView.swift
//  Organize
//
//  Created by Yuhao Chen on 1/27/24.
//

import SwiftUI

struct AuroraView: View {
    let style : AuroraAnimationStyle
    let patternColor : (Color, Color)
    let opacity : Double
    let speed: CGFloat
    let amplitude: CGFloat
    let frequency: CGFloat
    let timeline : TimelineViewDefaultContext
    let blur : Double
    
    init(patternColor: (Color, Color),
         opacity : Double = 1,
         speed : CGFloat = 1,
         animationStyle : AuroraAnimationStyle,
         shape : AuroraShapeStyle,
         blurMode : AuroraBlurStyle,
         timeline : TimelineViewDefaultContext) {
        self.patternColor = patternColor
        self.opacity = opacity
        self.speed = speed
        self.style = animationStyle
        self.amplitude = shape.amplitude()
        self.frequency = shape.frequency()
        self.blur = blurMode.rawValue
        self.timeline = timeline
    }
    
    init(style : AuroraAnimationStyle,
         patternColor: (Color, Color),
         opacity : Double = 1,
         blur : Double = 30,
         speed: CGFloat = 1,
         amplitude: CGFloat = 5,
         frequency: CGFloat = 20,
         timeline: TimelineViewDefaultContext) {
        self.patternColor = patternColor
        self.speed = speed
        self.amplitude = amplitude
        self.frequency = frequency
        self.timeline = timeline
        self.opacity = opacity
        self.blur = blur
        self.style = style
    }
    
    var body: some View {
        GeometryReader { geometry in
            let x = geometry.size.width
            let y = geometry.size.height
            let t = timeline.date.timeIntervalSinceReferenceDate
            let t2 = timeline.date.timeIntervalSince1970 - Date().timeIntervalSince1970
            let v = (sin(t) + 1)/2
            
            ZStack {
                let c0xDir = style.direction().0.x
                let c0yDir = style.direction().0.y
                let c1xDir = style.direction().1.x
                let c1yDir = style.direction().1.y
                
                let c0xSP = style.offsetStartingPoint().0.x
                let c0ySP = style.offsetStartingPoint().0.y
                let c1xSP = style.offsetStartingPoint().1.x
                let c1ySP = style.offsetStartingPoint().1.y
                
                let c0xOM = style.offsetMultiplier().0.x
                let c0yOM = style.offsetMultiplier().0.y
                let c1xOM = style.offsetMultiplier().1.x
                let c1yOM = style.offsetMultiplier().1.y
                
                let c0SS = style.startingScale().0
                let c1SS = style.startingScale().1
                
                let c0SM = style.scaleMultiplier().0
                let c1SM = style.scaleMultiplier().1
                
                Circle()
                    .fill(patternColor.0.gradient.opacity(opacity)).blur(radius: blur)
                    .scaleEffect((v * c0SM) + c0SS)
                    .offset(x: c0xDir * x/(c0xSP + v * c0xOM), y: c0yDir * y/(c0ySP + v * c0yOM))
                    
                Circle()
                    .fill(patternColor.1.gradient.opacity(opacity * 0.8)).blur(radius: blur)
                    .scaleEffect((v * c1SM) + c1SS)
                    .offset(x: c1xDir * x/(c1xSP + v * c1xOM), y: c1yDir * y/(c1ySP + v * c1yOM))
            }
            .distortionEffect(
                .init(
                    function: .init(library: .default, name: "wave"),
                    arguments: [
                        .float(t2),
                        .float(speed),
                        .float(frequency),
                        .float(amplitude)
                    ]
                ),
                maxSampleOffset: .zero
            )
        }
    }
}

#Preview {
    TimelineView(.animation()) { timeline in
        AuroraView(patternColor: (Color.accentColor, Color.accentColor), animationStyle: .meetAtMiddle, shape: .spiky, blurMode: .clear, timeline: timeline)
    }
}
