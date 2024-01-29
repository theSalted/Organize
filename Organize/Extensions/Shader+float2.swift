//
//  Shader+float2.swift
//  Organize
//
//  Created by Yuhao Chen on 1/30/24.
//

import SwiftUI

extension Shader.Argument {
    static func float2(_ unitPoint: UnitPoint) -> Self {
        self.float2(unitPoint.x, unitPoint.y)
    }
}
