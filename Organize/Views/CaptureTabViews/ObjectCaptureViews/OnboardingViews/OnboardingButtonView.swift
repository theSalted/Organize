//
//  OnboardingButtonView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/4/24.
//

import RealityKit
import SwiftUI
import os

#if !targetEnvironment(simulator)
@available(iOS 17.0, *)
/// View that creates the buttons on the review screen depending on
/// `currentState` in `onboardingStateMachine`.
struct OnboardingButtonView: View {
    @EnvironmentObject var objectCaptureModel: ObjectCaptureDataModel
    var session: ObjectCaptureSession
    @ObservedObject var onboardingStateMachine: CaptureOnBoardingStateMachine
    @State private var userHasIndicatedObjectCannotBeFlipped: Bool? = nil
    @State private var userHasIndicatedFlipObjectAnyway: Bool? = nil

    var body: some View {
        VStack {
            HStack {
                CancelButton(buttonLabel: LocalizedString.cancel)
                Spacer()
            }

            Spacer()

            VStack(spacing: 0) {
                let currentStateInputs = onboardingStateMachine.currentStateInputs()
                if currentStateInputs.contains(where: { $0 == .continue(isFlippable: false) || $0 == .continue(isFlippable: true) }) {
                    CreateButton(buttonLabel: LocalizedString.continue,
                                 buttonLabelColor: .white,
                                 shouldApplyBackground: true,
                                 action: { transition(with: .continue(isFlippable: objectCaptureModel.isObjectFlippable)) }
                    )
                }
                if currentStateInputs.contains(where: { $0 == .flipObjectAnyway }) {
                    CreateButton(buttonLabel: LocalizedString.flipAnyway,
                                 buttonLabelColor: .blue,
                                 action: {
                        userHasIndicatedFlipObjectAnyway = true
                        transition(with: .flipObjectAnyway)
                    })
                }
                if currentStateInputs.contains(where: { $0 == .skip(isFlippable: false) || $0 == .skip(isFlippable: true) }) {
                    CreateButton(buttonLabel: LocalizedString.skip,
                                 buttonLabelColor: .blue,
                                 action: {
                        transition(with: .skip(isFlippable: objectCaptureModel.isObjectFlippable))
                    })
                }
                if currentStateInputs.contains(where: { $0 == .finish }) {
                    CreateButton(buttonLabel: LocalizedString.finish,
                                 buttonLabelColor: onboardingStateMachine.currentState == .thirdSegmentComplete ? .white : .blue,
                                 shouldApplyBackground: onboardingStateMachine.currentState == .thirdSegmentComplete,
                                 showBusyIndicator: session.state == .finishing,
                                 action: { [weak session] in session?.finish() })
                }
                if currentStateInputs.contains(where: { $0 == .objectCannotBeFlipped }) {
                    CreateButton(buttonLabel: LocalizedString.cannotFlipYourObject,
                                 buttonLabelColor: .blue,
                                 action: {
                        userHasIndicatedObjectCannotBeFlipped = true
                        transition(with: .objectCannotBeFlipped)
                    })
                }
                if onboardingStateMachine.currentState == CaptureOnboardingState.tooFewImages ||
                    onboardingStateMachine.currentState == .secondSegmentComplete  ||
                    onboardingStateMachine.currentState == .thirdSegmentComplete {
                    CreateButton(buttonLabel: "", action: {})
                }
            }
            .padding(.bottom)
        }
    }

    private func reloadData() {
        switch onboardingStateMachine.currentState {
            case .firstSegment, .dismiss:
                objectCaptureModel.setPreviewModelState(shown: false)
            case .secondSegment, .thirdSegment, .additionalOrbitOnCurrentSegment:
                beginNewOrbitOrSection()
            default:
                break
        }
    }

    private func beginNewOrbitOrSection() {
        if let userHasIndicatedObjectCannotBeFlipped = userHasIndicatedObjectCannotBeFlipped {
            objectCaptureModel.hasIndicatedObjectCannotBeFlipped = userHasIndicatedObjectCannotBeFlipped
        }

        if let userHasIndicatedFlipObjectAnyway = userHasIndicatedFlipObjectAnyway {
            objectCaptureModel.hasIndicatedFlipObjectAnyway = userHasIndicatedFlipObjectAnyway
        }

        if !objectCaptureModel.isObjectFlippable && !objectCaptureModel.hasIndicatedFlipObjectAnyway {
            session.beginNewScanPass()
        } else {
            session.beginNewScanPassAfterFlip()
            objectCaptureModel.isObjectFlipped = true
        }
        objectCaptureModel.setPreviewModelState(shown: false)
        objectCaptureModel.orbitState = .initial
        objectCaptureModel.orbit = objectCaptureModel.orbit.next()
    }

    private func transition(with input: OnboardingUserInput) {
        guard onboardingStateMachine.enter(input) else {
            CreateButton.logger.log("Could not move to new state in User Guide state machine")
            return
        }
        reloadData()
    }
}

@available(iOS 17.0, *)
private struct CreateButton: View {
    static let logger = Logger(subsystem: OrganizeApp.bundleId,
                               category: "OnboardingButtonView")

    @EnvironmentObject var objectCaptureModel: ObjectCaptureDataModel
    let buttonLabel: String
    var buttonLabelColor: Color = Color.white
    var buttonBackgroundColor: Color = Color.blue
    var shouldApplyBackground = false
    var showBusyIndicator = false
    let action: () -> Void

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Button(
            action: {
                CreateButton.logger.log("\(buttonLabel) clicked!")
                action()
            },
            label: {
                ZStack {
                    if showBusyIndicator {
                        HStack {
                            Text(buttonLabel).hidden()
                            Spacer().frame(maxWidth: 48)
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(
                                    tint: shouldApplyBackground ? .white : (colorScheme == .light ? .black : .white)))
                        }
                    }
                    Text(buttonLabel)
                        .font(.headline)
                        .bold()
                        .foregroundColor(buttonLabelColor)
                        .padding()
                        .frame(maxWidth: .infinity)
                }
            })
        .if(shouldApplyBackground) { view in
            view.background(RoundedRectangle(cornerRadius: 16.0).fill(buttonBackgroundColor))
        }
        .padding(.leading)
        .padding(.trailing)
        .frame(maxWidth: UIDevice.current.userInterfaceIdiom == .pad ? 380 : .infinity)
    }
}

@available(iOS 17.0, *)
private struct CancelButton: View {
    static let logger = Logger(subsystem: OrganizeApp.bundleId,
                               category: "CancelButton")

    @EnvironmentObject var objectCaptureModel: ObjectCaptureDataModel
    let buttonLabel: String

    var body: some View {
        Button(
            action: {
                CancelButton.logger.log("Cancel button clicked!")
                objectCaptureModel.setPreviewModelState(shown: false)
            },
            label: {
                Text(buttonLabel)
                    .font(.headline)
                    .bold()
                    .padding(30)
                    .foregroundColor(.blue)
            })
    }
}
#endif
