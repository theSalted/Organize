//
//  OnboardingTutorialView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/4/24.
//


import Foundation
import RealityKit
import SwiftUI

#if !targetEnvironment(simulator)
/// The view that either shows the point cloud or plays the guidance tutorials on the review screens.
/// This depends on `currentState` in `onboardingStateMachine`.
@available(iOS 17.0, *)
struct OnboardingTutorialView: View {
    @EnvironmentObject var objectCaptureModel: ObjectCaptureDataModel
    var session: ObjectCaptureSession
    @ObservedObject var onboardingStateMachine: CaptureOnBoardingStateMachine

    var body: some View {
        VStack {
            ZStack {
                if shouldShowTutorialInReview, let url = tutorialUrl {
                    TutorialVideoView(url: url, isInReviewSheet: true)
                        .padding(30)
                } else {
                    ObjectCapturePointCloudView(session: session)
                        .padding(30)
                }

                VStack {
                    Spacer()
                    HStack {
                        ForEach(ObjectCaptureDataModel.Orbit.allCases) { orbit in
                            if let orbitImageName = getOrbitImageName(orbit: orbit) {
                                Text(Image(systemName: orbitImageName))
                                    .font(.system(size: 28))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.bottom)
                }
            }
            .frame(maxHeight: .infinity)

            VStack {
                Text(title)
                    .font(.largeTitle)
                    .lineLimit(3)
                    .minimumScaleFactor(0.5)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                    .frame(maxWidth: .infinity)

                Text(detailText)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                Spacer()
            }
            .frame(maxHeight: .infinity)
            .padding(.leading, UIDevice.current.userInterfaceIdiom == .pad ? 50 : 30)
            .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? 50 : 30)

        }
    }

    private var shouldShowTutorialInReview: Bool {
        switch onboardingStateMachine.currentState {
            case .flipObject, .flipObjectASecondTime, .captureFromLowerAngle, .captureFromHigherAngle:
                return true
            default:
                return false
        }
    }

    private let onboardingStateToTutorialNameMap: [CaptureOnboardingState: String] = [
        .flipObject: "ScanPasses-iPad-FixedHeight-2",
        .flipObjectASecondTime: "ScanPasses-iPad-FixedHeight-3",
        .captureFromLowerAngle: "ScanPasses-iPad-FixedHeight-unflippable-low",
        .captureFromHigherAngle: "ScanPasses-iPad-FixedHeight-unflippable-high"
    ]

    private var tutorialUrl: URL? {
        let videoName: String
        videoName = onboardingStateToTutorialNameMap[onboardingStateMachine.currentState] ?? "ScanPasses-iPad-FixedHeight-1"
        return Bundle.main.url(forResource: videoName, withExtension: "mp4")
    }

    private func getOrbitImageName(orbit: ObjectCaptureDataModel.Orbit) -> String? {
        guard let session = objectCaptureModel.objectCaptureSession else { return nil }
        let orbitCompleted = session.userCompletedScanPass
        let orbitCompleteImage = orbit <= objectCaptureModel.orbit ? orbit.imageSelected : orbit.image
        let orbitNotCompleteImage = orbit < objectCaptureModel.orbit ? orbit.imageSelected : orbit.image
        return orbitCompleted ? orbitCompleteImage : orbitNotCompleteImage
    }

    private let onboardingStateToTitleMap: [CaptureOnboardingState: String] = [
        .tooFewImages: LocalizedString.tooFewImagesTitle,
        .firstSegmentNeedsWork: LocalizedString.firstSegmentNeedsWorkTitle,
        .firstSegmentComplete: LocalizedString.firstSegmentCompleteTitle,
        .secondSegmentNeedsWork: LocalizedString.secondSegmentNeedsWorkTitle,
        .secondSegmentComplete: LocalizedString.secondSegmentCompleteTitle,
        .thirdSegmentNeedsWork: LocalizedString.thirdSegmentNeedsWorkTitle,
        .thirdSegmentComplete: LocalizedString.thirdSegmentCompleteTitle,
        .flipObject: LocalizedString.flipObjectTitle,
        .flipObjectASecondTime: LocalizedString.flipObjectASecondTimeTitle,
        .flippingObjectNotRecommended: LocalizedString.flippingObjectNotRecommendedTitle,
        .captureFromLowerAngle: LocalizedString.captureFromLowerAngleTitle,
        .captureFromHigherAngle: LocalizedString.captureFromHigherAngleTitle
    ]

    private var title: String {
        onboardingStateToTitleMap[onboardingStateMachine.currentState] ?? ""
    }

    private let onboardingStateTodetailTextMap: [CaptureOnboardingState: String] = [
        .tooFewImages: String(format: LocalizedString.tooFewImagesDetailText, ObjectCaptureDataModel.minNumImages),
        .firstSegmentNeedsWork: LocalizedString.firstSegmentNeedsWorkDetailText,
        .firstSegmentComplete: LocalizedString.firstSegmentCompleteDetailText,
        .secondSegmentNeedsWork: LocalizedString.secondSegmentNeedsWorkDetailText,
        .secondSegmentComplete: LocalizedString.secondSegmentCompleteDetailText,
        .thirdSegmentNeedsWork: LocalizedString.thirdSegmentNeedsWorkDetailText,
        .thirdSegmentComplete: LocalizedString.thirdSegmentCompleteDetailText,
        .flipObject: LocalizedString.flipObjectDetailText,
        .flipObjectASecondTime: LocalizedString.flipObjectASecondTimeDetailText,
        .flippingObjectNotRecommended: LocalizedString.flippingObjectNotRecommendedDetailText,
        .captureFromLowerAngle: LocalizedString.captureFromLowerAngleDetailText,
        .captureFromHigherAngle: LocalizedString.captureFromHigherAngleDetailText
    ]

    private var detailText: String {
        onboardingStateTodetailTextMap[onboardingStateMachine.currentState] ?? ""
    }
}
#endif
