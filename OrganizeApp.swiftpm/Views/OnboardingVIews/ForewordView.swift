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
        VStack(spacing: 30) {
            Spacer()
            Image("AppIcon-1024px")
                .resizable()
                .scaledToFit()
            
                .frame(height: 150)
            VStack {
                Text(
                    "Welcome To")
                .font(.system(.headline, design: .rounded))
                .lineSpacing(10)
                .multilineTextAlignment(.center)            .padding(.horizontal, 50)
                Text("Organize")
                    .font(.system(.largeTitle, weight: .bold))
                    .multilineTextAlignment(.center)            .padding(.horizontal, 50)
            }
            Divider()            .padding(.horizontal, 50)
            Text(
                "The idea for this app came from my grandma. She used to write everything down in a notebook, but she stopped because she couldn't see well anymore. When I visited her during the New Year, she told me about it. I'm not great at writing things down, so I decided to make this app to help her keep track of things again.\n\nThis app is dedicated to her.")
            .font(.system(.body, design: .default, weight: .regular))
            .lineSpacing(10)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 50)
            Spacer()
            Button("Continue") {
                withAnimation {
                    onboardViewModel.stage = .technology
                }
            }
            .buttonStyle(GlowingButtonStyle())
            .padding()
        }
    }
}

#Preview {
    ForewordView()
        .environment(OnboardViewModel())
}
