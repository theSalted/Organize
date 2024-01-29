//
//  CurtainStack.swift
//  Organize
//
//  Created by Yuhao Chen on 1/30/24.
//

import SwiftUI

struct CurtainStack<Foreground: View, Background: View>: View, Animatable {
    /// The position of the current drag operation, or `nil`.
    @State private var dragPosition: CGPoint?

    /// `true` if the bottom layer is revealed.
    @State private var isRevealed: Bool = false
    var foreground: Foreground
    var background: Background
    /// The number of folds the curtain has.
    var folds: Int
    init(folds: Int = 4, @ViewBuilder foreground: () -> Foreground, @ViewBuilder background: () -> Background) {
        self.folds = folds
        self.foreground = foreground()
        self.background = background()
    }

    var body: some View {
        GeometryReader { p in
            let maxX = p.size.width

            // A simple drag gesture.
            //
            // We want to track the the drag in the coorindate of this view,
            // not the view we will end up installing it on, thus requiring us
            // to reference an explicity coordinate space.
            let drag = DragGesture(minimumDistance: 0, coordinateSpace: .named("curtain"))
                .onChanged { v in
                    withAnimation(.interactiveSpring) {
                        var position = v.location
                        position.x = rubberClamp(44, position.x, 1_000_000)

                        dragPosition = position
                    }
                }
                .onEnded { v in
                    if v.predictedEndLocation.x < 100 {
                        isRevealed = true
                        
                        withAnimation {
                            dragPosition?.x = 44
                        }
                    } else {
                        isRevealed = false

                        withAnimation {
                            dragPosition?.x = maxX
                        }
                    }
                }

            ZStack {
                background
                    .safeAreaPadding(EdgeInsets(top: 0, leading: 44, bottom: 0, trailing: 0))

                foreground
                    .modifier(CurtainEffect(
                        foldCount: folds,
                        dragPosition: dragPosition ?? CGPoint(x: maxX, y: 0),
                        maxX: maxX
                    ))
                    .allowsHitTesting(!isRevealed)
                    .accessibilityHidden(isRevealed)
                    .shadow(radius: isRevealed ? 10 : 0)
            }
            .overlay(alignment: isRevealed ? .leading : .trailing) {
                // We install the `DragGesture` on an invisible rect on the edge
                // of the view. This makes sure the swipe can only be started
                // here.
                Color.clear
                    .contentShape(Rectangle())
                    .frame(width: 44)
                    .gesture(drag)
            }
            .coordinateSpace(.named("curtain"))
        }
    }
}



#Preview {
    NavigationStack {
        CurtainStack {
            GroupBox("Curtain") {
                VStack(alignment: .leading) {
                    Text("Curtain is Sick")
                    Text("I love it!!")
                }
                .frame(maxWidth: .infinity)
            }
        } background: {
            VStack {
                Text("On second thought..")
                Text("Still love it")
            }
        }
        .padding()
    }

}
