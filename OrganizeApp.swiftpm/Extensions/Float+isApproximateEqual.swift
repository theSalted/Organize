//
//  Float+isApproximateEqual.swift
//  Organize
//
//  Created by Yuhao Chen on 2/10/24.
//

import Foundation

extension Float {
    /// Checks if the current float is approximately equal to another float within a specified tolerance.
    ///
    /// - Parameters:
    ///   - value: The float value to compare with.
    ///   - tolerance: The maximum difference between the values for them to be considered approximately equal.
    /// - Returns: `true` if the values are approximately equal within the specified tolerance, otherwise `false`.
    func isApproximateEqual(to value: Float, tolerance: Float) -> Bool {
        return abs(self - value) <= tolerance
    }
}
