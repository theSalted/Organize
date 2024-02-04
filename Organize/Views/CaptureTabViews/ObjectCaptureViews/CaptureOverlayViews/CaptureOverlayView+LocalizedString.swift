//
//  CaptureOverlayView+LocalizedString.swift
//  Organize
//
//  Created by Yuhao Chen on 2/4/24.
//

import Foundation

extension CaptureOverlayView {
    struct LocalizedString {
        static let startCapture = NSLocalizedString(
            "Start Capture (Object Capture)",
            bundle: ObjectCaptureDataModel.bundleForLocalizedStrings,
            value: "Start Capture",
            comment: "Title for start capture button on the object capture screen.")

        static let resetBox = NSLocalizedString(
            "Reset Box (Object Capture)",
            bundle: ObjectCaptureDataModel.bundleForLocalizedStrings,
            value: "Reset Box",
            comment: "Title for resetting bounding box on the object capture screen.")

        static let `continue` = NSLocalizedString(
            "Continue (Object Capture, Capture)",
            bundle: ObjectCaptureDataModel.bundleForLocalizedStrings,
            value: "Continue",
            comment: "Title for continue button on the object capture screen.")

        static let next = NSLocalizedString(
            "Next (Object Capture)",
            bundle: ObjectCaptureDataModel.bundleForLocalizedStrings,
            value: "Next",
            comment: "Title for next button on the object capture screen.")

        static let cancel = NSLocalizedString(
            "Cancel (Object Capture)",
            bundle: ObjectCaptureDataModel.bundleForLocalizedStrings,
            value: "Cancel",
            comment: "Title for cancel button on the object capture screen.")

        static let numOfImages = NSLocalizedString(
            "%d/%d (Format, # of Images)",
            bundle: ObjectCaptureDataModel.bundleForLocalizedStrings,
            value: "%d/%d",
            comment: "Images taken over maximum number of images.")

        static let help = NSLocalizedString(
            "Help (Object Capture)",
            bundle: ObjectCaptureDataModel.bundleForLocalizedStrings,
            value: "Help",
            comment: "Title for help button on the object capture screen to show the tutorial pages.")
    }
}
