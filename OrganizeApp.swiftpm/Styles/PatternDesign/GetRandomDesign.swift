//
//  GetRandomDesign.swift
//  Organize
//
//  Created by Yuhao Chen on 1/28/24.
//

import Foundation
import OSLog

extension PatternDesign {
    static func getRandomDesign(
        patternOverwrite:                   Pattern? = nil,
        patternAnimationDirectionOverwrite: PatternView.Direction? = nil,
        auroraAnimationStyleOverwrite:      AuroraView.AuroraAnimationStyle? = nil,
        auroraShapeOverwrite:               AuroraView.AuroraShapeStyle? = nil,
        auroraBlurStyleOverwrite:           AuroraView.AuroraBlurStyle? = nil,
        opacityStyleOverwrite:              OpacityStyle? = nil,
        gradientEffect :                    GradientEffect? = nil
    ) -> PatternDesign {
        // Directly use the extended method on the collection
        let pattern =                   patternOverwrite ?? 
                                        Pattern.allCases.randomElement(or: .fishScale)
        let patternAnimationDirection = patternAnimationDirectionOverwrite ?? 
                                        PatternView.Direction.allCases.randomElement(or: .counterClockwise)
        let auroraAnimationStyle =      auroraAnimationStyleOverwrite ?? 
                                        AuroraView.AuroraAnimationStyle.allCases.randomElement(or: .meetAtMiddle)
        let auroraShape =               auroraShapeOverwrite ?? 
                                        AuroraView.AuroraShapeStyle.allCases.randomElement(or: .jelly)
        let auroraBlurStyle =           auroraBlurStyleOverwrite ??
                                        AuroraView.AuroraBlurStyle.allCases.randomElement(or: .halo)
        let opacityStyle =              opacityStyleOverwrite ??
                                        OpacityStyle.allCases.randomElement(or: .heavy)
        let gradientEffect =            gradientEffect ?? 
                                        GradientEffect.allCases.randomElement(or: .topLeadingToBottomTrailing)
        
        return PatternDesign(
            pattern:                   pattern,
            patternAnimationDirection: patternAnimationDirection,
            auroraAnimationStyle:      auroraAnimationStyle,
            auroraShape:               auroraShape,
            auroraBlurStyle:           auroraBlurStyle,
            opacityStyle:              opacityStyle,
            gradientEffect:            gradientEffect
        )
    }
}

fileprivate let logger = Logger(subsystem: OrganizeApp.bundleId, category: "PatternDesign+getRandomDesign")
