//
//  AuroraView.swift
//  Organize
//
//  Created by Yuhao Chen on 1/27/24.
//

import SwiftUI

struct AuroraView: View {
    let style:         AuroraAnimationStyle
    let patternColor: (Color, Color)
    let opacity:       Double
    let speed:         CGFloat
    let amplitude:     CGFloat
    let frequency:     CGFloat
    let strength:      CGFloat
    let blur:          Double
    let startDate =    Date()
    let waveType:      WaveType
    
    
    
    init(style:         AuroraAnimationStyle,
         patternColor: (Color, Color),
         waveType:      WaveType = .spiky,
         opacity:       Double = 1,
         blur:          Double = 30,
         speed:         CGFloat = 20,
         strength:      CGFloat = 10,
         amplitude:     CGFloat = 5,
         frequency:     CGFloat = 20) {
        self.patternColor = patternColor
        self.speed =        speed
        self.amplitude =    amplitude
        self.frequency =    frequency
        self.opacity =      opacity
        self.blur =         blur
        self.style =        style
        self.waveType =     waveType
        self.strength =     strength
    }
    
    init(patternColor:  (Color, Color),
         opacity:        Double = 1,
         speed:          CGFloat = 20,
         animationStyle: AuroraAnimationStyle,
         shape:          AuroraShapeStyle,
         blurMode:       AuroraBlurStyle) {
        self.patternColor = patternColor
        self.opacity =      opacity
        self.speed =        shape.speed()
        self.style =        animationStyle
        self.amplitude =    shape.amplitude()
        self.frequency =    shape.frequency()
        self.blur =         blurMode.rawValue
        self.waveType =     shape.waveType()
        self.strength =     shape.strength()
    }
    
    var body: some View {
        GeometryReader { geometry in
            TimelineView(.animation()) { timeline in
                let x = geometry.size.width
                let y = geometry.size.height
                let t = timeline.date.timeIntervalSinceReferenceDate
                let v = (sin(t) + 1)/2
                
                ZStack {
                    let c0xDir = style.direction().0.x
                    let c0yDir = style.direction().0.y
                    let c1xDir = style.direction().1.x
                    let c1yDir = style.direction().1.y
                    
                    let c0xSP =  style.offsetStartingPoint().0.x
                    let c0ySP =  style.offsetStartingPoint().0.y
                    let c1xSP =  style.offsetStartingPoint().1.x
                    let c1ySP =  style.offsetStartingPoint().1.y
                    
                    let c0xOM =  style.offsetMultiplier().0.x
                    let c0yOM =  style.offsetMultiplier().0.y
                    let c1xOM =  style.offsetMultiplier().1.x
                    let c1yOM =  style.offsetMultiplier().1.y
                    
                    let c0SS =   style.startingScale().0
                    let c1SS =   style.startingScale().1
                    
                    let c0SM =   style.scaleMultiplier().0
                    let c1SM =   style.scaleMultiplier().1
    
                    Circle()
                        .fill(patternColor.0.gradient.opacity(opacity)).blur(radius: blur)
                        .scaleEffect((v * c0SM) + c0SS)
                        .offset(x: c0xDir * x/(c0xSP + v * c0xOM), y: c0yDir * y/(c0ySP + v * c0yOM))
                        
                    Circle()
                        .fill(patternColor.1.gradient.opacity(opacity * 0.8)).blur(radius: blur)
                        .scaleEffect((v * c1SM) + c1SS)
                        .offset(x: c1xDir * x/(c1xSP + v * c1xOM), y: c1yDir * y/(c1ySP + v * c1yOM))
                }
                .visualEffect { content, proxy in
                    switch waveType {
                    case .simple:
                        content
                            .distortionEffect(ShaderLibrary.wave(
                                .float(startDate.timeIntervalSinceNow)
                            ), maxSampleOffset: .zero)
                    case .spiky:
                        content
                            .distortionEffect(ShaderLibrary.spikyWave(
                                .float(startDate.timeIntervalSinceNow),
                                .float(speed),
                                .float(frequency),
                                .float(amplitude)
                            ), maxSampleOffset: .zero)
                    case .complex:
                        content
                            .distortionEffect(ShaderLibrary.complexWave(
                                .float(startDate.timeIntervalSinceNow),
                                .float2(proxy.size),
                                .float(speed),
                                .float(frequency),
                                .float(strength)
                            ), maxSampleOffset: .zero)
                    }
                }

            }
            
        }
    }
}

#Preview {
    AuroraView(patternColor: (Color.accentColor, Color.accentColor), animationStyle: .meetAtMiddle, shape: .wavy, blurMode: .clear)
}
