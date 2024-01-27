//
//  FishScalePatternView.swift
//  Organize
//
//  Created by Yuhao Chen on 1/27/24.
//

import SwiftUI


struct PatternView: View {
    let pattern : Pattern
    let patternColor : Color
    let backgroundColor : Color
    let timeInterval : Double
    let opacity : Double
    
    init(_ pattern : Pattern, patternColor: Color, backgroundColor: Color, timeInterval: Double = 1, opacity: Double = 0.3) {
        self.pattern = pattern
        self.patternColor = patternColor
        self.backgroundColor = backgroundColor
        self.timeInterval = timeInterval
        self.opacity = opacity
    }
    
    var body: some View {
        let a = timeInterval.remainder(dividingBy: 360)
        let v = (sin(timeInterval) + 1)/2
        
        Rectangle()
            .fill()
            .fill(.fishScale(
                foregroundColor: patternColor.opacity(opacity),
                backgroundColor: backgroundColor,
                radius: 26,
                thickness: v - 0.5,
                angle: .degrees(a * 0.5)
            ))
    }
}

struct FishScalePatternView_Previews: PreviewProvider {
    static var previews: some View {
        let backgroundColor = Color(uiColor: UIColor.tertiarySystemBackground)
        PatternView(.fishScale ,patternColor: Color.accentColor, backgroundColor: backgroundColor, opacity: 1)
    }
}
