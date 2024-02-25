//
//  Clamp.swift
//  Organize
//
//  Created by Yuhao Chen on 1/30/24.
//

import Foundation

extension CurtainStack { 
    func clamp(_ min: CGFloat, _ value: CGFloat, _ max: CGFloat) -> CGFloat {
        Swift.max(min, Swift.min(value, max))
    }

    func rubberClamp(_ min: CGFloat, _ value: CGFloat, _ max: CGFloat, coefficient: CGFloat = 0.55) -> CGFloat {
        let clamped = clamp(min, value, max)

        let delta = abs(clamped - value)

        guard delta != 0 else {
            return value
        }

        let sign: CGFloat = clamped > value ? -1 : 1

        let range = (max - min)

        return clamped + sign * (1.0 - (1.0 / ((delta * coefficient / range) + 1.0))) * range
    }
}


