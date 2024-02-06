//
//  ReconstructionTitleView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/4/24.
//

import SwiftUI

#if !targetEnvironment(simulator)
struct ReconstructionTitleView: View {
    var body: some View {
        Text(LocalizedString.processingTitle)
            .font(.largeTitle)
            .fontWeight(.bold)

    }

    private struct LocalizedString {
        static let processingTitle = NSLocalizedString(
            "Processing title (Object Capture)",
            bundle: ObjectCaptureDataModel.bundleForLocalizedStrings,
            value: "Processing",
            comment: "Title of processing view during processing phase."
        )
    }
}
#endif
