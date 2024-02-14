//
//  AddObjectCaptureView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/15/24.
//

import SwiftUI
import OSLog

struct AddObjectCaptureView: View {
    private var logger = Logger(
        subsystem: OrganizeApp.bundleId,
        category: "AddObjectCaptureView")
    @State var captureViewModel = CaptureViewModel()
    #if !targetEnvironment(simulator)
    @StateObject var objectCaptureModel: ObjectCaptureDataModel = ObjectCaptureDataModel.instance
    #endif
    
    var body: some View {
        
        NavigationLink {
            #if !targetEnvironment(simulator)
            CaptureView()
                .sheet(isPresented: $captureViewModel.showReconstructionView) {
                    if let folderManager = objectCaptureModel.scanFolderManager {
                        ReconstructionPrimaryView(
                            outputFile: folderManager
                                .modelsFolder
                                .appendingPathComponent(
                                    objectCaptureModel.modelName +
                                    ".usdz"
                                )
                        )
                    }
                }
                .environmentObject(objectCaptureModel)
                .environment(captureViewModel)
                .alert(
                    objectCaptureModel.error != nil  ?
                        "Failed: \(String(describing: objectCaptureModel.error!))" :
                        "Failed object capture for unknown reason",
                    isPresented: $captureViewModel.showErrorAlert,
                    actions: {
                        Button("OK") {
        //                    ContentView.logger.log("Calling restart...")
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
            #else
            ContentUnavailableView("Object Capture Unavailable", systemImage: "exclamationmark.triangle.fill", description: "Simulator is not supported, please try again on a real device with LiDAR sensor".inText)
            #endif
        } label: {
            label
        }
    }
    
    var label: some View {
        Label {
            Text("Model")
        } icon: {
            Image(systemName: "cube.fill")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.white)
                .frame(width: 28, height: 28)
        }
        .labelStyle(ShapedLabelStyle(shape: .roundedRectangle(6), scaleEffect: 0.6, backgroundColor: .mint))
    }
}

#Preview {
    NavigationStack {
        AddObjectCaptureView()
    }
}
