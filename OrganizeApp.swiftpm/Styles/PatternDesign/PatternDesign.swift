//
//  PatternDesign.swift
//  Organize
//
//  Created by Yuhao Chen on 1/28/24.
//

import Foundation

struct PatternDesign : Codable {
    let pattern:                   Pattern
    let patternAnimationDirection: PatternView.Direction
    let auroraAnimationStyle:      AuroraView.AuroraAnimationStyle
    let auroraShape:               AuroraView.AuroraShapeStyle
    let auroraBlurStyle:           AuroraView.AuroraBlurStyle
    let opacityStyle:              OpacityStyle
    let gradientEffect:            GradientEffect
}
