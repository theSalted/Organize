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
        self.randomAuroraShapeList = PatternSelectionView.generateUniqueRandomList(of: availableSelectionCount)
        self.randomPatternList = PatternSelectionView.generateUniqueRandomList(of: availableSelectionCount)
    }
    
    var body: some View {
        ViewThatFits {
            horizontalPatterns
            verticalPatterns
        }
    }
    
    var horizontalPatterns: some View {
        HStack(spacing: 20) {
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
                        .frame(minWidth: 120)
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
                    .frame(width: 50, height: 50)
                    .padding()
            }
        }
    }
    
    var verticalPatterns: some View {
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
    }
    func randomizeLists() {
        withAnimation {
            self.randomAuroraShapeList = PatternSelectionView.generateUniqueRandomList(of: availableSelectionCount)
            self.randomPatternList = PatternSelectionView.generateUniqueRandomList(of: availableSelectionCount)
        }
    }
}

extension PatternSelectionView {
    /// Generates a unique random list of elements from an enumeration.
    ///
    /// This function creates a list of unique elements of a given size from an enumeration that conforms to `CaseIterable` and `Equatable`. It shuffles the collection of all cases and then takes the first `n` elements, ensuring uniqueness without the need to check for duplicates.
    ///
    /// - Parameters:
    ///   - elementCount: The desired number of unique elements in the list. Defaults to 3 if not specified. If `elementCount` is greater than the number of available cases, the function returns a shuffled list of all cases.
    /// - Returns: An array of unique random elements of type `T`.
    ///
    /// - Complexity: O(n), where n is the number of cases in the enumeration. This is due to the shuffling operation.
    static func generateUniqueRandomList<T>(of elementCount: Int = 3) -> [T] where T: CaseIterable, T: Equatable {
        let allCasesShuffled = T.allCases.shuffled()
        return Array(allCasesShuffled.prefix(elementCount))
    }
}

#Preview {
    PatternSelectionView(.constant(PatternDesign.getRandomDesign()), color: .accentColor).padding()
}
