//
//  GlowingButtonStyle.swift
//  Organize
//
//  Created by Yuhao Chen on 2/23/24.
//

import SwiftUI

struct GlowingButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .bold()
            .frame(maxWidth: .infinity)
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 10, style: .circular).stroke(LinearGradient(colors: [.accentColor, .accentColor, .accentColor.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 10).blur(radius: configuration.isPressed ? 5 : 15))
            .background(.black)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
            .scaleEffect(configuration.isPressed ? 1.03 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .opacity(isEnabled ? 1 : 0.5)
    }
}

