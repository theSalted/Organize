//
//  PatternDesign.swift
//  Organize
//
//  Created by Yuhao Chen on 1/28/24.
//

import Foundation
import OSLog

struct PatternDesign : Codable {
    let pattern : Pattern
    let patternAnimationDirection : PatternView.Direction
    let auroraAnimationStyle : AuroraView.AuroraAnimationStyle
    let auroraShape : AuroraView.AuroraShapeStyle
    let auroraBlurStyle : AuroraView.AuroraBlurStyle
    let opacityStyle : OpacityStyle
}

extension PatternDesign {
    enum OpacityStyle : CaseIterable, Codable {
        case light, medium, heavy
        func patternOpacityValue() -> Double {
            switch self {
            case .light: 0.3
            case .medium: 0.5
            case .heavy: 1
            }
        }
        
        func auroraOpacityValue() -> Double {
            switch self {
            case .light: 0.2
            case .medium: 0.5
            case .heavy: 0.7
            }
        }
    }
}

extension PatternDesign {
    private static let logger = Logger(subsystem: OrganizeApp.bundleId, category: "PatternDesign")
    
    static func getRandomDesign(
        patternOverwrite : Pattern? = nil,
        patternAnimationDirectionOverwrite : PatternView.Direction? = nil,
        auroraAnimationStyleOverwrite : AuroraView.AuroraAnimationStyle? = nil,
        auroraShapeOverwrite : AuroraView.AuroraShapeStyle? = nil,
        auroraBlurStyleOverwrite : AuroraView.AuroraBlurStyle? = nil,
        opacityStyleOverwrite : OpacityStyle? = nil
    ) -> PatternDesign {
        if let randomPattern = 
            Pattern.allCases.randomElement(),
           let randomAnimationDirection = 
            PatternView.Direction.allCases.randomElement(),
           let randomAuroraAnimationStyle =
            AuroraView.AuroraAnimationStyle.allCases.randomElement(),
           let randomAuroraShape =
            AuroraView.AuroraShapeStyle.allCases.randomElement(),
           let randomAuroraBlurStyle =
            AuroraView.AuroraBlurStyle.allCases.randomElement(),
           let randomOpacityStyle =
            OpacityStyle.allCases.randomElement()
        {
            return PatternDesign(
                pattern: 
                    patternOverwrite ?? randomPattern,
                patternAnimationDirection: 
                    patternAnimationDirectionOverwrite ?? randomAnimationDirection,
                auroraAnimationStyle:
                    auroraAnimationStyleOverwrite ?? randomAuroraAnimationStyle,
                auroraShape:
                    auroraShapeOverwrite ?? randomAuroraShape,
                auroraBlurStyle:
                    auroraBlurStyleOverwrite ?? randomAuroraBlurStyle,
                opacityStyle:
                    opacityStyleOverwrite ?? randomOpacityStyle)
        } else {
            return PatternDesign(
                pattern: 
                    patternOverwrite ?? .fishScale,
                patternAnimationDirection: 
                    patternAnimationDirectionOverwrite ?? .counterClockwise,
                auroraAnimationStyle:
                    auroraAnimationStyleOverwrite ?? .meetAtMiddle,
                auroraShape:
                    auroraShapeOverwrite ?? .jelly,
                auroraBlurStyle:
                    auroraBlurStyleOverwrite ?? .halo,
                opacityStyle: 
                    opacityStyleOverwrite ?? .heavy)
        }
    }
}

