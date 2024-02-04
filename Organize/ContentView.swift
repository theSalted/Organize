//
//  ContentView.swift
//  Organize
//
//  Created by Yuhao Chen on 1/21/24.
//

import SwiftUI
import SwiftData
import OSLog

struct ContentView: View {
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @StateObject var objectCaptureModel: ObjectCaptureDataModel = ObjectCaptureDataModel.instance
    @State var appModel = AppViewModel()
    @State var captureViewModel = CaptureViewModel()
    private var logger = Logger(
        subsystem: OrganizeApp.bundleId, category: "ContentView")
    
    var body: some View {
        TabView(selection: $appModel.tabViewSelection) {
            OrganizationView()
                .tabItem {
                    Label("Organize", systemImage: "circle.grid.3x3.fill")
                }
                .tag(AppViewModel.TabViewTag.storage)
                .toolbar(
                    verticalSizeClass == .compact ?
                        .hidden : .automatic,
                    for: .tabBar)
                .toolbarBackground(.hidden, for: .tabBar)
                
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
                .tabItem {
                    Label("Scan", systemImage: "cube.fill")
                }
                .toolbar(
                    verticalSizeClass == .compact ? 
                        .hidden : .automatic,
                    for: .tabBar)
                .tag(AppViewModel.TabViewTag.scan)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarColorScheme(.dark, for: .tabBar)
                .environmentObject(objectCaptureModel)
                .environment(captureViewModel)
                
        }
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
        .environment(appModel)
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
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Space.self, inMemory: true)
}
