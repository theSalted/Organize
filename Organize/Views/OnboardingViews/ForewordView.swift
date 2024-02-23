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
                "The inspiration of this app comes from Grandma. She used to have this habit of keeping inventory of everything in a notebook. When I visited her during the New Year, she told me she stopped because her vision. I decided I would help her to record again. Me being not so good at note taking, I decided to develop an app.")
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
