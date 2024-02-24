//
//  Pattern.swift
//  Organize
//
//  Created by Yuhao Chen on 1/27/24.
//

import SwiftUI

#Preview {
    Grid {
        GridRow {
            Rectangle()
                .fill(.halfToneDots(
                    foregroundColor: .pink,
                    backgroundColor: .teal,
                    radius: 10,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))

            Rectangle()
                .fill(.polkaDots(
                    foregroundColor: .blue,
                    backgroundColor: .red,
                    angle: .degrees(-7),
                    patternSize: CGSize(width: 30, height: 50)
                ))
        }

        Rectangle()
            .fill(.fishScale(
                foregroundColor: .white,
                backgroundColor: .blue.opacity(0.3),
                radius: 26,
                thickness: 1.5,
                angle: .degrees(12)
            ))

        GridRow {
            Rectangle()
                .fill(.waves(
                    colors: [.mint, .blue, .pink, .blue],
                    angle: .degrees(90)
                ))

            Rectangle()
                .fill(.lines(
                    colors: [.red, .white, .yellow, .white],
                    width: 15,
                    angle: .degrees(45)
                ))
        }
    }
    .edgesIgnoringSafeArea(.all)
}

enum Pattern : CaseIterable, Codable {
    case halfToneDots, pokaDots, fishScale, lines, waves
}

// See Pattern.metal for notes on the individual patterns.
extension ShapeStyle where Self == AnyShapeStyle {
    static func halfToneDots(
        foregroundColor: Color = .primary,
        backgroundColor: Color = .accentColor,
        radius: Double = 4,
        patternSize: CGSize? = nil,
        startPoint: UnitPoint = .leading,
        endPoint: UnitPoint = .trailing) -> Self {
            
        let d = radius * 2
        let size = patternSize ?? CGSize(width: d, height: d);

        return AnyShapeStyle(ShaderLibrary.default.halfToneDots(
            .boundingRect,
            .float(radius),
            .float2(startPoint.x, startPoint.y),
            .float2(endPoint.x, endPoint.y),
            .float2(size),
            .color(foregroundColor),
            .color(backgroundColor)
        ))
    }

    static func polkaDots(
        foregroundColor: Color = .primary,
        backgroundColor: Color = .accentColor,
        radius: Double = 8,
        angle: Angle = .zero,
        offset: CGSize = .zero,
        patternSize: CGSize? = nil) -> Self {
            
        let d = radius * 3 * sqrt(2)
        let size = patternSize ?? CGSize(width: d, height: d)
            
        return AnyShapeStyle(ShaderLibrary.default.polkaDots(
            .boundingRect,
            .float(radius),
            .float(angle.radians),
            .float2(offset),
            .float2(size),
            .color(foregroundColor),
            .color(backgroundColor)
        ))
    }

    static func fishScale(
        foregroundColor: Color = .primary,
        backgroundColor: Color = .accentColor,
        radius: Double = 20, thickness: Double = 2,
        angle: Angle = .zero,
        offset: CGSize = .zero) -> Self {
            
        AnyShapeStyle(ShaderLibrary.default.fishScale(
            .boundingRect,
            .float(radius),
            .float(thickness),
            .float(angle.radians),
            .float2(offset),
            .color(foregroundColor),
            .color(backgroundColor)
        ))
    }

    static func lines(
        colors: [Color],
        width: CGFloat = 10,
        angle: Angle = .zero,
        offset: CGSize = .zero) -> Self {
            
        AnyShapeStyle(ShaderLibrary.default.lines(
            .boundingRect,
            .float(width),
            .float(angle.radians),
            .float2(offset),
            .colorArray(colors)
        ))
    }

    static func waves(
        colors: [Color],
        width: CGFloat = 10,
        angle: Angle = .zero, 
        offset: CGSize = .zero,
        patternSize: CGSize? = nil) -> Self {
            
        AnyShapeStyle(ShaderLibrary.default.waves(
            .boundingRect,
            .float(width),
            .float(angle.radians),
            .float2(offset),
            .float2(patternSize ?? CGSize(width: width * 10, height: 4 * width)),
            .colorArray(colors)
        ))
    }
}
