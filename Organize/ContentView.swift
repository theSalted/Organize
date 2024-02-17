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
    #if !targetEnvironment(simulator)
    @StateObject var objectCaptureModel: ObjectCaptureDataModel = ObjectCaptureDataModel.instance
    #endif
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
                .tag(AppViewModel.TabViewTag.organize)
                .toolbar(
                    verticalSizeClass == .compact ?
                        .hidden : .automatic,
                    for: .tabBar)
                .toolbarBackground(.hidden, for: .tabBar)
                .environment(captureViewModel)
            #if !targetEnvironment(simulator)
            CaptureView()
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
            #endif
        }
        #if !targetEnvironment(simulator)
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
        #endif
        .environment(appModel)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Space.self, inMemory: true)
}
