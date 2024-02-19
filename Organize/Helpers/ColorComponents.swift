//
//  ColorComponents.swift
//  Organize
//
//  Created by Yuhao Chen on 1/29/24.
//

import SwiftUI
import OSLog

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

// TODO: Improve how this is implemented, I use the ApproximateEqualTo as a temporary fix. If we strictly compare the RGB values somehow sometimes same color doesn't match. Using an approximate equal with an arbitrary tolerance of 1e-8 seems to fix the issue in the **couple** colors I tested. **NO GUARANTEE** this works for all color, **NO GUARANTEE** this doesn't mix up two colors. Checklist: 1) Investigate new ways to save color to SwiftData without using this ColorComponents workaround or any other workaround 2) Investigate why same color can have two different RGB values. Is it related how SwiftUI resolves Color for light/dark mode? If so, this issue is even more dangerous than it might appear right now. 3) If this deviation is something very innocent (e.g. inaccuracy in bits), figure out what is lowest tolerance threshold.
extension ColorComponents: Equatable {
//    @available(*, deprecated, message: "This is a temporary workaround implementation. Not a strict Equatable implementation. Use with caution.")
    static func == (lhs: Self, rhs: Self) -> Bool {
        Logger(subsystem: OrganizeApp.bundleId, category: "ColorComponents+Equatable")
            .warning("You are comparing two ColorComponents. Implementation of Equatable for ColorComponents  is approximated and not exact. This supposed to be a temporary fix related to SwiftData could't save color and same color‘s RGB aren't exactly the same. Use with caution.")
        return
            lhs.red.isApproximateEqual(to: rhs.red, tolerance: 0.0000001) &&
            lhs.blue.isApproximateEqual(to: rhs.blue, tolerance: 0.0000001) &&
            lhs.green.isApproximateEqual(to: rhs.green, tolerance: 0.0000001)
    }
}
