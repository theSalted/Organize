//
//  AuroraView+Styles.swift
//  Organize
//
//  Created by Yuhao Chen on 1/28/24.
//

import Foundation

extension AuroraView {
    enum AuroraBlurStyle : Double, CaseIterable, Codable {
        case clear = 10
        case halo = 30
        case blurry = 100
    }
    enum WaveType {
        case simple, spiky, complex
    }
    enum AuroraShapeStyle : CaseIterable, Codable {
        case spiky, fluffy, wavy, puffy, jelly, slimey
        func amplitude() -> Double {
            switch self {
            case .spiky: 20
            case .fluffy, .wavy: 5
            case .puffy, .jelly, .slimey: 0
            }
        }
        func frequency() -> Double {
            switch self {
            case .spiky: 2
            case .fluffy: 2
            case .wavy: 20
            case .puffy: 0 //Ignore frequency
            case .jelly: 10
            case .slimey: 5
            }
        }
        func strength() -> Double {
            switch self {
            // These ignore strength
            case .spiky, .fluffy, .wavy, .puffy:
                1
            case .jelly:
                8
            case .slimey:
                20
            }
        }
        func speed() -> Double {
            switch self.waveType() {
            case .simple: 0 // Don't care speed
            case .spiky: 20
            case .complex: 0.5
            }
        }
        func waveType() -> WaveType {
            switch self {
            case .fluffy, .wavy, .spiky:
                .spiky
            case .puffy:
                .simple
            case .jelly, .slimey:
                .complex
            }
        }
    }
    enum AuroraAnimationStyle : CaseIterable, Codable {
        case dipFromTop, riseToMiddle, downToMiddle, meetAtMiddle, meetAtMiddleMirrored
        func direction() -> (CGPoint, CGPoint) {
            switch self {
            case .dipFromTop, .downToMiddle:
                (CGPoint(x: -1, y: -1), CGPoint(x: 1, y: -1))
            case .riseToMiddle:
                (CGPoint(x: -1, y: 1), CGPoint(x: 1, y: 1))
            case .meetAtMiddle:
                (CGPoint(x: -1, y: 1), CGPoint(x: 1, y: -1))
            case .meetAtMiddleMirrored:
                (CGPoint(x: -1, y: -1), CGPoint(x: 1, y: 1))
            }
        }
        func offsetStartingPoint() -> (CGPoint, CGPoint) {
            switch self {
            case .dipFromTop:
                (CGPoint(x: 2, y: 2), CGPoint(x: 3, y: 1.5))
            case .downToMiddle:
                (CGPoint(x: 2, y: 2), CGPoint(x: 1, y: 2.5))
            case .riseToMiddle:
                (CGPoint(x: 2.2, y: 1.2), CGPoint(x: 1.3, y: 1.5))
            case .meetAtMiddle:
                (CGPoint(x: 2, y: 1.2), CGPoint(x: 1.5, y: 3))
            case .meetAtMiddleMirrored:
                (CGPoint(x: 2, y: 2), CGPoint(x: 2, y: 1.2))
            }
        }
        func offsetMultiplier() -> (CGPoint, CGPoint) {
            switch self {
            case .dipFromTop:
                (CGPoint(x: 1, y: 1.3), CGPoint(x: 1, y: 0.7))
            case .riseToMiddle:
                (CGPoint(x: 3, y: 7), CGPoint(x: 3, y: 5))
            case .downToMiddle:
                (CGPoint(x: 1, y: 6), CGPoint(x: 7, y: 3))
            case .meetAtMiddle:
                (CGPoint(x: 10, y: 10), CGPoint(x: 7, y: 10))
            case .meetAtMiddleMirrored:
                (CGPoint(x: 1, y: 20), CGPoint(x: 9, y: 20))
            }
        }
        func startingScale() -> (CGFloat, CGFloat) {
            switch self {
            case .dipFromTop:
                (0.6 , 0.4)
            case .riseToMiddle:
                (1 , -0.5)
            case .downToMiddle:
                (1.1 , -0.9)
            case .meetAtMiddle:
                (1 , -1)
            case .meetAtMiddleMirrored:
                (1 , -1.1)
            }
        }
        func scaleMultiplier() -> (CGFloat, CGFloat) {
            switch self {
            case .dipFromTop:
                (0.7, 1)
            case .riseToMiddle:
                (0.7, -1)
            case .downToMiddle:
                (0.7, 0.5)
            case .meetAtMiddle:
                (0.8, 0.7)
            case .meetAtMiddleMirrored:
                (0.7, 0.7)
            }
        }
    }
}
