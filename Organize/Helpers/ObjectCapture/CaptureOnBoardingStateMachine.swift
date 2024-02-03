//
//  CaptureOnBoardingStateMachine.swift
//  Organize
//
//  Created by Yuhao Chen on 2/3/24.
//

import Foundation
import os

/// The state machine used by `OnboardingView` to show the tutorial and texts
/// depending on its `currentState`.
/// The state transitions happen based on the user inputs in `OnboardingButtonView`.
class CaptureOnBoardingStateMachine: ObservableObject {
    static let logger = Logger(subsystem: OrganizeApp.bundleId,
                                category: "CaptureOnBoardingStateMachine")

    let logger = CaptureOnBoardingStateMachine.logger
    @Published var currentState: CaptureOnboardingState

    init(_ state: CaptureOnboardingState = .firstSegment) {
        guard initialStates.contains(state) else {
            currentState = .firstSegment
            return
        }
        currentState = state
    }

    func enter(_ input: OnboardingUserInput) -> Bool {
        let transitions = transitions(for: currentState)

        if transitions.isEmpty {
            let stateString = "\(currentState)"
            logger.debug("No transitions available for '\(stateString)'")
            return false
        }

        guard let destinationState = transitions.first(where: { $0.inputs.contains(where: { $0 == input }) })?.destination else {
            let stateString = "\(currentState)"
            let inputString = "\(input)"
            logger.debug("No transition from '\(stateString)' for: \(inputString)")
            return false
        }
        currentState = destinationState
        return true
    }

    func currentStateInputs() -> [OnboardingUserInput] {
        let transitions = transitions(for: currentState)

        return transitions.reduce([], { $0 + $1.inputs })
    }

    func reset(to state: CaptureOnboardingState) -> Bool {
        guard initialStates.contains(state) else {
            let stateString = "\(state)"
            logger.debug("Invalid internal state '\(stateString)'.")
            return false
        }

        currentState = state
        return true
    }

    // Allowed initial states.
    private let initialStates: [CaptureOnboardingState] = [.tooFewImages, .firstSegmentNeedsWork, .firstSegmentComplete,
                                                    .secondSegmentNeedsWork, .secondSegmentComplete,
                                                    .thirdSegmentNeedsWork, .thirdSegmentComplete]

    // State transitions based on the user input.
    typealias Transition = (inputs: [OnboardingUserInput], destination: CaptureOnboardingState)
    private let transitions: [CaptureOnboardingState: [Transition]] = [
        .tooFewImages: [(inputs: [.continue(isFlippable: true), .continue(isFlippable: false)], destination: .firstSegment)],

        .firstSegmentNeedsWork: [(inputs: [.continue(isFlippable: true), .continue(isFlippable: false)], destination: .firstSegment),
                                 (inputs: [.skip(isFlippable: true), .skip(isFlippable: false)], destination: .flipObject)],

        .firstSegmentComplete: [(inputs: [.finish], destination: .reconstruction),
                                (inputs: [.continue(isFlippable: true)], destination: .flipObject),
                                (inputs: [.continue(isFlippable: false)], destination: .flippingObjectNotRecommended)],

        .flipObject: [(inputs: [.continue(isFlippable: true), .continue(isFlippable: false)], destination: .secondSegment),
                      (inputs: [.objectCannotBeFlipped], destination: .captureFromLowerAngle)],

        .flippingObjectNotRecommended: [(inputs: [.continue(isFlippable: true), .continue(isFlippable: false)], destination: .captureFromLowerAngle),
                                        (inputs: [.flipObjectAnyway], destination: .flipObject)],

        .captureFromLowerAngle: [(inputs: [.finish], destination: .reconstruction),
                                 (inputs: [.continue(isFlippable: true), .continue(isFlippable: false)],
                                  destination: .additionalOrbitOnCurrentSegment)],

        .secondSegmentNeedsWork: [(inputs: [.continue(isFlippable: true), .continue(isFlippable: false)], destination: .dismiss),
                                  (inputs: [.skip(isFlippable: true)], destination: .flipObjectASecondTime),
                                  (inputs: [.skip(isFlippable: false)], destination: .captureFromHigherAngle)],

        .secondSegmentComplete: [(inputs: [.continue(isFlippable: true)], destination: .flipObjectASecondTime),
                                 (inputs: [.continue(isFlippable: false)], destination: .captureFromHigherAngle)],

        .flipObjectASecondTime: [(inputs: [.finish], destination: .reconstruction),
                                 (inputs: [.continue(isFlippable: true), .continue(isFlippable: false)], destination: .thirdSegment)],

        .captureFromHigherAngle: [(inputs: [.finish], destination: .reconstruction),
                                  (inputs: [.continue(isFlippable: true),
                                            .continue(isFlippable: false)],
                                   destination: .additionalOrbitOnCurrentSegment)],

        .thirdSegmentNeedsWork: [(inputs: [.finish], destination: .reconstruction),
                                 (inputs: [.continue(isFlippable: true), .continue(isFlippable: false)], destination: .dismiss)],

        .thirdSegmentComplete: [(inputs: [.finish], destination: .reconstruction)]
    ]

    private func transitions(for state: CaptureOnboardingState) -> [(inputs: [OnboardingUserInput], destination: CaptureOnboardingState)] {
        guard let transitions = transitions[state] else {
            let stateString = "\(state)"
            logger.debug("No transition exists for '\(stateString)'.")
            return []
        }

        return transitions
    }
}

// States for transitioning the review screens.
enum CaptureOnboardingState: Equatable, Hashable {
    case dismiss
    case tooFewImages
    case firstSegment
    case firstSegmentNeedsWork
    case firstSegmentComplete
    case secondSegment
    case secondSegmentNeedsWork
    case secondSegmentComplete
    case thirdSegment
    case thirdSegmentNeedsWork
    case thirdSegmentComplete
    case flipObject
    case flipObjectASecondTime
    case flippingObjectNotRecommended
    case captureFromLowerAngle
    case captureFromHigherAngle
    case reconstruction
    case additionalOrbitOnCurrentSegment
}

// User input on the review screens.
enum OnboardingUserInput: Equatable {
    case `continue`(isFlippable: Bool)
    case skip(isFlippable: Bool)
    case finish
    case objectCannotBeFlipped
    case flipObjectAnyway
}

