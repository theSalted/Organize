//
//  OpacityStyle.swift
//  Organize
//
//  Created by Yuhao Chen on 1/28/24.
//

import Foundation

extension PatternDesign {
    enum OpacityStyle : CaseIterable, Codable {
        case light, medium, heavy
        func patternOpacityValue() -> Double {
            switch self {
            case .light:  0.3
            case .medium: 0.5
            case .heavy:  1
            }
        }
        
        func auroraOpacityValue() -> Double {
            switch self {
            case .light:  0.2
            case .medium: 0.5
            case .heavy:  0.7
            }
        }
    }
}
