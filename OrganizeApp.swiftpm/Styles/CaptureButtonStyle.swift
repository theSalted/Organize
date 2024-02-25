//
//  CaptureButtonStyle.swift
//  Organize
//
//  Created by Yuhao Chen on 2/24/24.
//

import SwiftUI

struct CaptureButtonStyle : ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        CaptureButton(configuration: configuration)
    }
    struct CaptureButton: View {
            let configuration: ButtonStyle.Configuration
            @Environment(\.isEnabled) private var isEnabled: Bool
            var body: some View {
                Spacer()
                    .frame(maxWidth: 25, maxHeight: 25)
                    .padding()
                    .background(.white, in: Circle().scale( configuration.isPressed ? 0.9 : 1.0, anchor: .center))
                    .padding(5)
                    .background(.white, in: Circle().stroke(lineWidth: 5))
                    .opacity(isEnabled ? 1 : 0.3)
            }
    }
}

