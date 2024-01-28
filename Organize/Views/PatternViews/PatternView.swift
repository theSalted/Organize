//
//  FishScalePatternView.swift
//  Organize
//
//  Created by Yuhao Chen on 1/27/24.
//

import SwiftUI


struct PatternView: View {
    let pattern : Pattern
    let patternColor : Color
    let backgroundColor : Color
    let timeInterval : Double
    let opacity : Double
    let direction : Direction
    
    
    init(_ pattern : Pattern,
         patternColor: Color,
         backgroundColor: Color,
         timeInterval: Double = 1,
         opacity: Double = 0.3,
         direction : Direction = .counterClockwise) {
        self.pattern = pattern
        self.patternColor = patternColor
        self.backgroundColor = backgroundColor
        self.timeInterval = timeInterval
        self.opacity = opacity
        self.direction = direction
    }
    
    var body: some View {
        let a = timeInterval.remainder(dividingBy: 360)
        let v = (sin(timeInterval) + 1)/2
        let aMultiplier = direction.angle()
        switch pattern {
        case .halfToneDots:
            Rectangle().fill(
                .halfToneDots(
                    foregroundColor: patternColor.opacity((opacity * 0.3) + (v * opacity * 0.7) + 0.3),
                    backgroundColor: backgroundColor,
                    radius: 5 + (0.1 * v), 
                    patternSize: CGSize(width: 20 - v, height: 20 - (v * 2)),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
        case .pokaDots:
            Rectangle().fill(
                .polkaDots(
                    foregroundColor: patternColor.opacity((opacity * 0.3) + (v * opacity * 0.7)),
                    backgroundColor: backgroundColor,
                    radius: 7,
                    angle: .degrees(a * -3 * aMultiplier),
                    offset: CGSize(width: 20 * v, height: 20 * v),
                    patternSize: CGSize(width: 50 - (v * 30), height: 30)
                ))
        case .fishScale:
            Rectangle().fill(
                .fishScale(
                    foregroundColor: patternColor.opacity(opacity),
                    backgroundColor: backgroundColor,
                    radius: 26,
                    thickness: v - 0.5,
                    angle: .degrees(a * 0.5 * aMultiplier)
                ))
        case .lines:
            Rectangle().fill(
                .lines(colors: [
                    patternColor.opacity(opacity - (0.7 * opacity * v)),
                    backgroundColor,
                    patternColor.opacity(opacity - (0.3 * opacity * v)),
                    backgroundColor,
                    patternColor.opacity(opacity - (opacity * v)),
                    backgroundColor
                    ],
                       width: 20 - (5 * v),
                       angle: .degrees(a * aMultiplier * 10),
                       offset: CGSize(width: 20 * v, height: 20 * v))
            ).blur(radius: 5)
        case .waves:
            Rectangle().fill(
                .waves(colors: [
                    patternColor.opacity(opacity - (0.7 * opacity * v)),
                    backgroundColor,
                    patternColor.opacity(opacity - (0.3 * opacity * v)),
                    backgroundColor,
                    patternColor.opacity(opacity - (opacity * v)),
                    backgroundColor
                    ],
                       width: 20 - (5 * v),
                       angle: .degrees(-1 * a * aMultiplier),
                       offset: CGSize(width: 20 * v, height: 20 * v),
                       patternSize: CGSize(width: 50 - (v * 10), height: 50)
                      )
            ).blur(radius: 5)
        }
    }
}

extension PatternView {
    enum Direction : CaseIterable, Codable {
        case clockwise, counterClockwise
        
        func angle() -> Double {
            switch self {
            case .clockwise: -1
            case .counterClockwise: 1 }
        }
    }
}

struct FishScalePatternView_Previews: PreviewProvider {
    static var previews: some View {
        let backgroundColor = Color(uiColor: UIColor.tertiarySystemBackground)
        PatternView(.halfToneDots, patternColor: Color.orange, backgroundColor: backgroundColor, opacity: 1)
    }
}
