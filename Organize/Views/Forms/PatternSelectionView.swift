//
//  PatternSelectionView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/11/24.
//

import SwiftUI

struct PatternSelectionView: View {
    let availableSelectionCount: Int
    let color: Color
    @Binding var patternTarget: PatternDesign
    
    @State var randomAuroraShapeList: [AuroraView.AuroraShapeStyle]
    @State var randomPatternList: [Pattern]
    
    init(_ pattern: Binding<PatternDesign>, color: Color, of availableSelectionCount: Int = 3) {
        self._patternTarget = pattern
        self.color = color
        self.availableSelectionCount = availableSelectionCount
        self.randomAuroraShapeList = PatternSelectionView.generateRandomList(of: availableSelectionCount)
        self.randomPatternList = PatternSelectionView.generateRandomList(of: availableSelectionCount)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            ForEach(0...(availableSelectionCount - 1), id: \.self) { i in
                let pattern = PatternDesign.getRandomDesign(
                    patternOverwrite: randomPatternList[i],
                    auroraShapeOverwrite: randomAuroraShapeList[i])
                
                Button {
                    withAnimation {
                        patternTarget = pattern
                    }
                    randomizeLists()
                } label: {
                    PatternCardView(design: pattern, color: color)
                        .frame(height: 120)
                }
            }
            
            Button {
                randomizeLists()
            } label: {
                Image(systemName: "arrow.clockwise.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(color)
                    .symbolRenderingMode(.hierarchical)
                    .frame(width: 40, height: 40)
            }
        }
        .tint(color)
        .buttonStyle(.plain)
    }
    
    func randomizeLists() {
        withAnimation {
            self.randomAuroraShapeList = PatternSelectionView.generateRandomList(of: availableSelectionCount)
            self.randomPatternList = PatternSelectionView.generateRandomList(of: availableSelectionCount)
        }
    }
}

extension PatternSelectionView {
    static func generateRandomList<T>(of size: Int = 3) -> [T] where T: CaseIterable, T: Equatable  {
        var randomListOfShapes = [T]()
        for _ in 1...size {
            while let randomShape = T.allCases.randomElement() {
                if !randomListOfShapes.contains(where: { $0 == randomShape}) {
                    randomListOfShapes.append(randomShape)
                    break;
                }
            }
        }
        
        return randomListOfShapes
    }
}

#Preview {
    PatternSelectionView(.constant(PatternDesign.getRandomDesign()), color: .accentColor).padding()
}
