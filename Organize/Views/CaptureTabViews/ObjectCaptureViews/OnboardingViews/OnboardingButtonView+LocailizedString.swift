//
//  OnboardingButtonView+LocailizedString.swift
//  Organize
//
//  Created by Yuhao Chen on 2/4/24.
//

import Foundation

extension OnboardingButtonView {
    struct LocalizedString {
        static let `continue` = NSLocalizedString(
            "Continue (Object Capture, Point Cloud)",
            bundle: ObjectCaptureDataModel.bundleForLocalizedStrings,
            value: "Continue",
            comment: "Title of button to continue to flip the object and capture more."
        )

        static let finish = NSLocalizedString(
            "Finish (Object Capture, Point Cloud)",
            bundle: ObjectCaptureDataModel.bundleForLocalizedStrings,
            value: "Finish",
            comment: "Title for finish button on the object capture screen."
        )

        static let skip = NSLocalizedString(
            "Skip (Object Capture, Point Cloud)",
            bundle: ObjectCaptureDataModel.bundleForLocalizedStrings,
            value: "Skip",
            comment: "Title for skip button on the object capture screen."
        )

        static let cannotFlipYourObject = NSLocalizedString(
            "Can't flip your object? (Object Capture, Point Cloud)",
            bundle: ObjectCaptureDataModel.bundleForLocalizedStrings,
            value: "Can't flip your object?",
            comment: "Title for button on the object capture screen that lets users indicate that their object cannot be flipped."
        )

        static let flipAnyway = NSLocalizedString(
            "Flip object anyway (Object Capture, Point Cloud)",
            bundle: ObjectCaptureDataModel.bundleForLocalizedStrings,
            value: "Flip object anyway",
            comment: "Title for button on the object capture screen that lets users indicate they want to flip their object."
        )

        static let cancel = NSLocalizedString(
            "Cancel (Object Capture, Point Cloud)",
            bundle: ObjectCaptureDataModel.bundleForLocalizedStrings,
            value: "Cancel",
            comment: "Title of button to close review page."
        )
    }
}
