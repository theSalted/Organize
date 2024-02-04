//
//  ObjectCaptureOnboardingView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/4/24.
//

import Foundation
import RealityKit
import SwiftUI

@available(iOS 17.0, *)
/// View that shows the guidance text and tutorials on the review screen.
struct ObjectCaptureOnboardingView: View {
    @EnvironmentObject var objectCaptureModel: ObjectCaptureDataModel
    @StateObject private var stateMachine: CaptureOnBoardingStateMachine
    @Environment(\.colorScheme) private var colorScheme

    init(state: CaptureOnboardingState) {
        _stateMachine = StateObject(wrappedValue: CaptureOnBoardingStateMachine(state))
    }

    var body: some View {
        ZStack {
            Color(colorScheme == .light ? .white : .black).ignoresSafeArea()
            if let session = objectCaptureModel.objectCaptureSession {
                OnboardingTutorialView(session: session, onboardingStateMachine: stateMachine)
                OnboardingButtonView(session: session, onboardingStateMachine: stateMachine)
            }
        }
        .interactiveDismissDisabled(objectCaptureModel.objectCaptureSession?.userCompletedScanPass ?? false)
        .allowsHitTesting(!isFinishingOrCompleted)
    }

    private var isFinishingOrCompleted: Bool {
        guard let session = objectCaptureModel.objectCaptureSession else { return true }
        return session.state == .finishing || session.state == .completed
    }
}

