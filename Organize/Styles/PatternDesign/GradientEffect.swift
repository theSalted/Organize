//
//  GradientEffect.swift
//  Organize
//
//  Created by Yuhao Chen on 1/28/24.
//

import SwiftUI

extension PatternDesign {
    enum GradientEffect: CaseIterable, Codable {
        case noGradient,
             topToBottom,
             bottomToTop,
             topLeadingToBottomTrailing,
             topTrailingToBottomLeading,
             leadingToTrailing,
             trailingToLeading
        var startingPoint: UnitPoint? {
            switch self {
            case .noGradient:                 nil
            case .topToBottom:                UnitPoint.top
            case .bottomToTop:                UnitPoint.bottom
            case .topLeadingToBottomTrailing: UnitPoint.topLeading
            case .topTrailingToBottomLeading: UnitPoint.topTrailing
            case .leadingToTrailing:          UnitPoint.leading
            case .trailingToLeading:          UnitPoint.trailing
            }
        }
        var endPoint: UnitPoint? {
            switch self {
            case .noGradient:                 nil
            case .topToBottom:                UnitPoint.bottom
            case .bottomToTop:                UnitPoint.top
            case .topLeadingToBottomTrailing: UnitPoint.bottomTrailing
            case .topTrailingToBottomLeading: UnitPoint.bottomLeading
            case .leadingToTrailing:          UnitPoint.trailing
            case .trailingToLeading:          UnitPoint.leading
            }
        }
    }
}
