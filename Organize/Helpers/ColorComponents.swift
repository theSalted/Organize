//
//  ColorComponents.swift
//  Organize
//
//  Created by Yuhao Chen on 1/29/24.
//

import SwiftUI

struct ColorComponents: Codable {
    let red: Float
    let green: Float
    let blue: Float

    var color: Color {
        Color(red: Double(red), green: Double(green), blue: Double(blue))
    }

    static func fromColor(_ color: Color) -> ColorComponents {
        let resolved = color.resolve(in: EnvironmentValues())
        return ColorComponents(
            red: resolved.red,
            green: resolved.green,
            blue: resolved.blue
        )
    }
}

extension ColorComponents: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return
            lhs.red.isApproximateEqual(to: rhs.red, tolerance: 0.0000001) &&
            lhs.blue.isApproximateEqual(to: rhs.blue, tolerance: 0.0000001) &&
            lhs.green.isApproximateEqual(to: rhs.green, tolerance: 0.0000001)
    }
}
