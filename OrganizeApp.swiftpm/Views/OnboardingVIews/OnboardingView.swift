//
//  OnboardingView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/23/24.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(OnboardViewModel.self) private var onboardViewModel
    
    var body: some View {
        switch onboardViewModel.stage {
        case .foreword:
            ForewordView()
        case .technology:
            TechnologiesView()
        case .tip:
            OnboardTipView()
        }
    }
}

#Preview {
    OnboardingView()
        .environment(OnboardViewModel())
}
