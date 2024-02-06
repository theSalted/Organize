//
//  ProcessingStage+String.swift
//  Organize
//
//  Created by Yuhao Chen on 2/4/24.
//

import Foundation
import RealityKit

#if !targetEnvironment(simulator)
extension PhotogrammetrySession.Output.ProcessingStage {
    var string: String? {
        switch self {
            case .preProcessing:
                return NSLocalizedString(
                    "Pre-Processing (Reconstruction)",
                    bundle: ObjectCaptureDataModel.bundleForLocalizedStrings,
                    value: "Pre-Processing…",
                    comment: "Feedback message during the object reconstruction phase."
                )
            case .imageAlignment:
                return NSLocalizedString(
                    "Aligning Images (Reconstruction)",
                    bundle: ObjectCaptureDataModel.bundleForLocalizedStrings,
                    value: "Aligning Images…",
                    comment: "Feedback message during the object reconstruction phase."
                )
            case .pointCloudGeneration:
                return NSLocalizedString(
                    "Generating Point Cloud (Reconstruction)",
                    bundle: ObjectCaptureDataModel.bundleForLocalizedStrings,
                    value: "Generating Point Cloud…",
                    comment: "Feedback message during the object reconstruction phase."
                )
            case .meshGeneration:
                return NSLocalizedString(
                    "Generating Mesh (Reconstruction)",
                    bundle: ObjectCaptureDataModel.bundleForLocalizedStrings,
                    value: "Generating Mesh…",
                    comment: "Feedback message during the object reconstruction phase."
                )
            case .textureMapping:
                return NSLocalizedString(
                    "Mapping Texture (Reconstruction)",
                    bundle: ObjectCaptureDataModel.bundleForLocalizedStrings,
                    value: "Mapping Texture…",
                    comment: "Feedback message during the object reconstruction phase."
                )
            case .optimization:
                return NSLocalizedString(
                    "Optimizing (Reconstruction)",
                    bundle: ObjectCaptureDataModel.bundleForLocalizedStrings,
                    value: "Optimizing…",
                    comment: "Feedback message during the object reconstruction phase."
                )
            default:
                return nil
        }
    }
}
#endif
