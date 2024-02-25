//
//  PatternCardView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/9/24.
//

import SwiftUI

struct PatternCardView: View {
    let design: PatternDesign
    let color: Color
    var body: some View {
        ZStack {
            PatternDesignView(design, patternColor: color)
                .clipShape(RoundedRectangle(cornerRadius: 25))
            RoundedRectangle(cornerRadius: 25)
                .stroke(
                    LinearGradient(
                        stops: [
                            .init(color: .white, location: 0.1),
                            .init(color: color.opacity(0.2), location: 0.5),
                            .init(color: Color.clear, location: 1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottom), lineWidth: 1.5)
        }
        .shadow(color: color.opacity(0.7), radius: 12)
    }
}

#Preview {
    PatternCardView(design: PatternDesign.getRandomDesign(), color: .accentColor)
        .frame(height: 200)
        .padding()
}
