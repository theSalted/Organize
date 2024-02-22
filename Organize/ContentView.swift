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
//    @StateObject var objectCaptureModel: ObjectCaptureDataModel = ObjectCaptureDataModel.instance
    #endif
    @StateObject var spaceScanViewModel = SpaceScanViewModel()
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
            ItemCaptureView()
                .tabItem {
                    Label("Capture", systemImage: "cube.fill")
                }
                .toolbar(
                    verticalSizeClass == .compact ? 
                        .hidden : .automatic,
                    for: .tabBar)
                .tag(AppViewModel.TabViewTag.capture)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarColorScheme(.dark, for: .tabBar)
                .environment(captureViewModel)
            #endif
            SpaceScanView()
                .tabItem {
                    Label("Scan", systemImage: "square.split.bottomrightquarter.fill")
                }
                .environmentObject(spaceScanViewModel)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarColorScheme(.dark, for: .tabBar)
        }
        
        .environment(appModel)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Space.self, inMemory: true)
}
