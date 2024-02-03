//
//  CaptureView.swift
//  Organize
//
//  Created by Yuhao Chen on 1/22/24.
//

import SwiftUI
import RealityKit

struct CaptureView: View {
    var body: some View {
        if ObjectCaptureSession.isSupported {
            Text("CaptureView")
        } else {
            ContentUnavailableView(
                "This Device is Not Supported",
                systemImage: "exclamationmark.triangle.fill",
                description: Text("Object Capture is not available for your device. Please use a device equipped with LiDAR."))
        }
    }
}

#Preview {
    CaptureView()
}
