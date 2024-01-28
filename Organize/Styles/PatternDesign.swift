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
        patternOverwrite: Pattern? = nil,
        patternAnimationDirectionOverwrite: PatternView.Direction? = nil,
        auroraAnimationStyleOverwrite: AuroraView.AuroraAnimationStyle? = nil,
        auroraShapeOverwrite: AuroraView.AuroraShapeStyle? = nil,
        auroraBlurStyleOverwrite: AuroraView.AuroraBlurStyle? = nil,
        opacityStyleOverwrite: OpacityStyle? = nil
    ) -> PatternDesign {
        // Directly use the extended method on the collection
        let pattern = patternOverwrite ?? Pattern.allCases.randomElement(or: .fishScale)
        let patternAnimationDirection = patternAnimationDirectionOverwrite ?? PatternView.Direction.allCases.randomElement(or: .counterClockwise)
        let auroraAnimationStyle = auroraAnimationStyleOverwrite ?? AuroraView.AuroraAnimationStyle.allCases.randomElement(or: .meetAtMiddle)
        let auroraShape = auroraShapeOverwrite ?? AuroraView.AuroraShapeStyle.allCases.randomElement(or: .jelly)
        let auroraBlurStyle = auroraBlurStyleOverwrite ?? AuroraView.AuroraBlurStyle.allCases.randomElement(or: .halo)
        let opacityStyle = opacityStyleOverwrite ?? OpacityStyle.allCases.randomElement(or: .heavy)
        return PatternDesign(
            pattern: pattern,
            patternAnimationDirection: patternAnimationDirection,
            auroraAnimationStyle: auroraAnimationStyle,
            auroraShape: auroraShape,
            auroraBlurStyle: auroraBlurStyle,
            opacityStyle: opacityStyle
        )
    }
}

