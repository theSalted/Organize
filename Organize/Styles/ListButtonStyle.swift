//
//  ColoredListButtonStyle.swift
//  Organize
//
//  Created by Yuhao Chen on 2/15/24.
//

import SwiftUI

struct ListButtonStyle: ButtonStyle {

  func makeBody(configuration: Self.Configuration) -> some View {
      configuration.label
          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
          .contentShape(Rectangle())
          .foregroundColor(configuration.isPressed ? Color.white.opacity(0.5) : Color.white)  }
}
