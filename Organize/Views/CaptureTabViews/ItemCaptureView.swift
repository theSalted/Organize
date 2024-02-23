//
//  CaptureView.swift
//  Organize
//
//  Created by Yuhao Chen on 1/22/24.
//

import SwiftUI
import RealityKit
import OSLog

#if !targetEnvironment(simulator)
struct ItemCaptureView: View {
    @StateObject var objectCaptureModel: ObjectCaptureDataModel = ObjectCaptureDataModel.instance
    @Environment(CaptureViewModel.self) private var captureViewModel
    
    private var showProgressView: Bool {
        objectCaptureModel.state == .completed ||
        objectCaptureModel.state == .restart ||
        objectCaptureModel.state == .ready
    }
    
    private var viewState : CaptureViewState {
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
        @Bindable var captureViewModel = captureViewModel
        NavigationStack {
            VStack {
                switch viewState {
                case .capturing:
                    // `objectCaptureModel.objectCaptureSession` can be forceful unwrapped
                    // as long as it's checked in viewState property
                    CubicObjectCaptureView(session: objectCaptureModel.objectCaptureSession!)
                        .toolbarBackground(.visible, for: .navigationBar)
                        .toolbarColorScheme(.dark, for: .navigationBar)
                        .navigationTitle($captureViewModel.item.name)
                        .navigationBarTitleDisplayMode(.inline)
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
        }
        .onAppear { objectCaptureModel.resumeSession() }
        .onDisappear { objectCaptureModel.stopSession() }
        .sheet(isPresented: $captureViewModel.showReconstructionView) {
            // TODO: We need a better implementation, but I think that would trigger an entire rewrite
            withAnimation {
                // Present create item form on dismiss of reconstruction view
                captureViewModel.showCreateForm = true
            }
        } content: {
            if let folderManager = objectCaptureModel.scanFolderManager {
                ReconstructionPrimaryView(
                    outputFile: folderManager
                        .modelsFolder
                        .appendingPathComponent(
                            captureViewModel.item.name +
                            ".usdz"
                        )
                )
            }
        }
        .alert(
            objectCaptureModel.error != nil  ?
                "Failed: \(String(describing: objectCaptureModel.error!))" :
                "Failed object capture for unknown reason",
            isPresented: $captureViewModel.showErrorAlert,
            actions: {
                Button("OK") {
                    logger.info("Restarting Capture")
                    objectCaptureModel.state = .restart
                }
            },
            message: {}
        )
        .onChange(of: objectCaptureModel.state) { _, newState in
            if newState == .failed {
                captureViewModel.showErrorAlert = true
                captureViewModel.showReconstructionView = false
            } else {
                captureViewModel.showErrorAlert = false
                captureViewModel.showReconstructionView =
                    newState == .reconstructing ||
                    newState == .viewing
            }
        }
        .environmentObject(objectCaptureModel)
    }
}

extension ItemCaptureView {
    enum CaptureViewState {
        case capturing, progressing, unsupportedDevice, errorState
    }
}

fileprivate let logger = Logger(subsystem: OrganizeApp.bundleId, category: "ItemCaptureView")
#endif
