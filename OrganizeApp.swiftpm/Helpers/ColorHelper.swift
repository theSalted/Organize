//
//  ColorHelper.swift
//  Organize
//
//  Created by Yuhao Chen on 1/28/24.
//

import SwiftUI

let templateColors : [Color] = [.red, .green, .blue, .yellow, .purple, .brown, .cyan, .indigo, .mint, .pink, .teal]

func getRandomColorFromTemplate() -> Color {
    templateColors.randomElement(or: .accentColor)
}
