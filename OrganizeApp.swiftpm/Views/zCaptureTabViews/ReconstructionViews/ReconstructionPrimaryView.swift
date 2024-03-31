//
//  ReconstructionPrimaryView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/4/24.
//

import Foundation
import RealityKit
import SwiftUI
import os

#if !(targetEnvironment(simulator) || targetEnvironment(macCatalyst))
@available(iOS 17.0, *)
struct ReconstructionPrimaryView: View {
    private let logger = Logger(subsystem: OrganizeApp.bundleId,
                                category: "ReconstructionPrimaryView")
    
    @EnvironmentObject var objectCaptureModel: ObjectCaptureDataModel
    @Environment(CaptureViewModel.self) private var captureViewModel
    let outputFile: URL

    @State private var completed: Bool = false
    @State private var cancelled: Bool = false

    var body: some View {
        if completed && !cancelled {
            CapturedObjectARQuickLookView(modelFile: outputFile) { [weak objectCaptureModel] in
                logger.notice("End Capture")
                objectCaptureModel?.endCapture()
            }
        } else {
            ReconstructionProgressView(outputFile: outputFile,
                                       completed: $completed,
                                       cancelled: $cancelled)
            .onAppear {
                UIApplication.shared.isIdleTimerDisabled = true
            }
            .onDisappear {
                UIApplication.shared.isIdleTimerDisabled = false
            }
            .interactiveDismissDisabled()
        }
    }
}

@available(iOS 17.0, *)
struct ReconstructionProgressView: View {
    @Environment(\.modelContext) private var modelContext
    static let logger = Logger(subsystem: OrganizeApp.bundleId,
                               category: "ReconstructionProgressView")

    let logger = ReconstructionProgressView.logger

    @EnvironmentObject var objectCaptureModel: ObjectCaptureDataModel
    @Environment(CaptureViewModel.self) private var captureViewModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    let outputFile: URL
    @Binding var completed: Bool
    @Binding var cancelled: Bool

    @State private var progress: Float = 0
    @State private var estimatedRemainingTime: TimeInterval?
    @State private var processingStageDescription: String?
    @State private var pointCloud: PhotogrammetrySession.PointCloud?
    @State private var gotError: Bool = false
    @State private var error: Error?
    @State private var isCancelling: Bool = false
        
    private var padding: CGFloat {
        horizontalSizeClass == .regular ? 60.0 : 24.0
    }
    private func isReconstructing() -> Bool {
        return !completed && !gotError && !cancelled
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                ReconstructionTitleView()
                ReconstructionProgressBarView(progress: progress,
                                estimatedRemainingTime: estimatedRemainingTime,
                                processingStageDescription: processingStageDescription)
                .padding(padding)
            }
            .frame(maxWidth: .infinity)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(LocalizedString.cancel) {
                        logger.log("Cancelling reconstruction...")
                        isCancelling = true
                        objectCaptureModel.photogrammetrySession?.cancel()
                    }
                }
            }
        }
        .alert(
            "Failed:  " + (error != nil  ? "\(String(describing: error!))" : ""),
            isPresented: $gotError,
            actions: {
                Button("OK") {
                    logger.log("Calling restart...")
                    objectCaptureModel.state = .restart
                }
            },
            message: {}
        )
        .task { await reconstructionTask() }
    }
    
    private func reconstructionTask() async {
        precondition(objectCaptureModel.state == .reconstructing)
        assert(objectCaptureModel.photogrammetrySession != nil)
        let session = objectCaptureModel.photogrammetrySession!

        let outputs = UntilPhotogrammetryProcessingCompleteFilter(input: session.outputs)
        do {
            try session.process(requests: [.modelFile(url: outputFile)])
        } catch {
            logger.error("Processing the session failed!")
        }
        
        await processingOutput(outputs)
        
        logger.info(">>>>>>>>>> RECONSTRUCTION TASK EXIT >>>>>>>>>>>>>>>>>")
    }
    
    private func processingOutput(
        _ outputs: UntilPhotogrammetryProcessingCompleteFilter<PhotogrammetrySession.Outputs>
    ) async {
        
        for await output in outputs {
            switch output {
                case .inputComplete:
                    break
                case .requestProgress(let request, fractionComplete: let fractionComplete):
                    if case .modelFile = request {
                        progress = Float(fractionComplete)
                    }
                case .requestProgressInfo(let request, let progressInfo):
                    if case .modelFile = request {
                        estimatedRemainingTime = progressInfo.estimatedRemainingTime
                        processingStageDescription = progressInfo.processingStage?.string
                    }
                case .requestComplete(let request, _):
                    switch request {
                        case .modelFile(_, _, _):
                            logger.log("RequestComplete: .modelFile")
                        case .modelEntity(_, _), .bounds, .poses, .pointCloud:
                            // Not supported yet
                            break
                        @unknown default:
                            logger.warning("Received an output for an unknown request: \(String(describing: request))")
                    }
                case .requestError(_, let requestError):
                    if !isCancelling {
                        gotError = true
                        error = requestError
                    }
                case .processingComplete:
                    if !gotError {
                        completed = true
                        // Insert object
                        createCapturedObject()
                        objectCaptureModel.state = .viewing
                    }
                case .processingCancelled:
                    cancelled = true
                    objectCaptureModel.state = .restart
                case .invalidSample(id: _, reason: _), .skippedSample(id: _), .automaticDownsampling:
                    continue
                case .stitchingIncomplete:
                    break
                @unknown default:
                    logger.warning("Received an unknown output: \(String(describing: output))")
            }
        }
    }
    
    private func createCapturedObject() {
        let object = CapturedObject(captureViewModel.item.name, at: objectCaptureModel.scanFolderManager.relativeRoot)
        
        // Generate Preview images
        if let modelURL = object.modelURL {
            CapturedObject.generateThumbnailFromURL(
                with: modelURL,
                size: CGSize(width: 128, height: 128)
            ) { thumbnail in
                object.thumbnail = thumbnail
                try? modelContext.save()
            }
        }

        if let modelURL = object.modelURL {
            CapturedObject.generateThumbnailFromURL(
                with: modelURL,
                size: CGSize(width: 1024, height: 1024))
            { thumbnail in
                object.previewImage = thumbnail
                captureViewModel.item.image = thumbnail
                try? modelContext.save()
            }
        }
        
        withAnimation {
            captureViewModel.item.capture = object
        }
        
        modelContext.insert(object)
        try? modelContext.save()
    }

    struct LocalizedString {
        static let cancel = NSLocalizedString(
            "Cancel (Object Reconstruction)",
            bundle: ObjectCaptureDataModel.bundleForLocalizedStrings,
            value: "Cancel",
            comment: "Button title to cancel reconstruction")
    }

}
#endif