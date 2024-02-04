//
//  CaptureView.swift
//  Organize
//
//  Created by Yuhao Chen on 1/22/24.
//

import SwiftUI
import RealityKit

struct CaptureView: View {
    @EnvironmentObject var objectCaptureModel: ObjectCaptureDataModel
    var showProgressView: Bool {
        objectCaptureModel.state == .completed ||
        objectCaptureModel.state == .restart ||
        objectCaptureModel.state == .ready
    }
    
    var viewState : CaptureViewState {
        guard ObjectCaptureSession.isSupported else {
            return .unsupportedDevice
        }
        if objectCaptureModel.state == .capturing,
           objectCaptureModel.objectCaptureSession != nil {
            return .capturing
        } else if showProgressView {
            return .progressing
        } else {
            return .errorState
        }
    }
    
    var body: some View {
        VStack {
            switch viewState {
            case .capturing:
                // `objectCaptureModel.objectCaptureSession` can be forceful unwrapped
                // as long as it's checked in viewState property
                CubicObjectCaptureView(session: objectCaptureModel.objectCaptureSession!)
            case .progressing:
                CircularProgressView()
            case .unsupportedDevice:
                ContentUnavailableView(
                    "This Device is Not Supported",
                    systemImage: "exclamationmark.triangle.fill",
                    description: "Object Capture is not available for your device. Please use a device equipped with LiDAR.".inText)
            case .errorState:
                ContentUnavailableView(
                    "Something Went Wrong...",
                    systemImage: "exclamationmark.triangle.fill",
                    description: "We can't initiate Object Capture. Please try again later".inText)
            }
        }
        .onAppear { objectCaptureModel.resumeSession() }
        .onDisappear { objectCaptureModel.pauseSession() }
    }
}

extension CaptureView {
    enum CaptureViewState {
        case capturing, progressing, unsupportedDevice, errorState
    }
}

#Preview {
    CaptureView()
}
