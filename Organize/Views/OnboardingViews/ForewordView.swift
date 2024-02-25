//
//  ForewordView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/23/24.
//

import SwiftUI

struct ForewordView: View {
    @Environment(OnboardViewModel.self) private var onboardViewModel
    
    var body: some View {
        VStack(spacing: 25) {
            Text("Organize")
                .font(.system(.title, weight: .bold))
                .multilineTextAlignment(.center)
            Text(
                "Welcome to Organize.\nThe idea for this app came from my grandma. She used to write everything down in a notebook, but she stopped because she couldn't see well anymore. When I visited her during the New Year, she told me about it. I'm not great at writing things down, so I decided to make this app to help her keep track of things again.\nThis app is dedicated to her.")
                .font(.system(.body, design: .default, weight: .regular))
                .lineSpacing(10)
                .multilineTextAlignment(.center)
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button("Continue") {
                    withAnimation {
                        onboardViewModel.showOnboarding = false
                    }
                }
                .buttonStyle(GlowingButtonStyle())
                .padding(.bottom)
            }
        }
    }
}

#Preview {
    ForewordView()
        .environment(OnboardViewModel())
}
