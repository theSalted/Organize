//
//  CapturedObjectARQuickLookView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/4/24.
//

import ARKit
import QuickLook
import SwiftUI
import UIKit
import os

struct CapturedObjectARQuickLookView: View {
    let modelFile: URL
    let endCaptureCallback: () -> Void

    var body: some View {
        CapturedObjectARQuickLookRepresentable(modelFile: modelFile, endCaptureCallback: endCaptureCallback)
    }
}
