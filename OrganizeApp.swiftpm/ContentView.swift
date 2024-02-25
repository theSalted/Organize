//
//  ContentView.swift
//  Organize
//
//  Created by Yuhao Chen on 1/21/24.
//

import SwiftUI
import SwiftData
import TipKit
import OSLog

struct ContentView: View {
    @Query var storages: [Storage]
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @StateObject var spaceScanViewModel = SpaceScanViewModel()
    @State var appModel = AppViewModel()
    @State var captureViewModel = CaptureViewModel()
    @State var onboardViewModel = OnboardViewModel()
    @State var cameraDataModel = CameraDataModel()
    
    @AppStorage("isFirstLaunch", store: .standard) var isFirstLaunch: Bool = true
    
    private let logger = Logger(
        subsystem: OrganizeApp.bundleId, category: "ContentView")
    
    init() {
        if isFirstLaunch {
            onboardViewModel.showOnboarding = true
            isFirstLaunch = false
        }
    }
    
    var body: some View {
        @Bindable var captureViewModel = captureViewModel
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
                .environment(onboardViewModel)
                .environment(captureViewModel)
                .environmentObject(spaceScanViewModel)
#if !targetEnvironment(simulator)
            ItemCaptureView()
                .overlay {
                    if storages.isEmpty {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.regularMaterial)
                            ContentUnavailableView(
                                "Create a Storage First",
                                systemImage: "archivebox",
                                description: "Can't create item because there is no available storage for them".inText)
                        }
                        .frame(height: 500)
                        .padding()
                    }
                }
                .disabled(storages.isEmpty)
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
                .tag(AppViewModel.TabViewTag.scan)
                .environmentObject(spaceScanViewModel)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarColorScheme(.dark, for: .tabBar)
        }
        .sheet(isPresented: $onboardViewModel.showOnboarding) {
            OnboardingView()
                .environment(onboardViewModel)
                .interactiveDismissDisabled()
        }
        .environment(cameraDataModel)
        .environment(appModel)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Space.self, inMemory: true)
}
