//
//  ForewordView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/23/24.
//

import SwiftUI

struct ForewordView: View {
    var body: some View {
        VStack(spacing: 25) {
            Text("Organize")
                .font(.system(.title, weight: .bold))
                .multilineTextAlignment(.center)
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button("Continue") {
                    withAnimation {
                        
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
}
