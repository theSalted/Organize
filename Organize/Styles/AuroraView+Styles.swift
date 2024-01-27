//
//  AuroraView+Styles.swift
//  Organize
//
//  Created by Yuhao Chen on 1/28/24.
//

import Foundation

extension AuroraView {
    enum AuroraBlurStyle : Double, CaseIterable {
        case clear = 10
        case halo = 30
        case blurry = 100
    }
    enum AuroraShapeStyle : CaseIterable {
        case spiky, fluffy, smokey
        func amplitude() -> Double {
            switch self {
            case .spiky: 20
            case .fluffy: 5
            case .smokey: 5
            }
        }
        func frequency() -> Double {
            switch self {
            case .spiky: 2
            case .fluffy: 2
            case .smokey: 20
            }
        }
    }
    enum AuroraAnimationStyle : CaseIterable {
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
                (CGPoint(x: 1, y: 2), CGPoint(x: 1, y: 1))
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
