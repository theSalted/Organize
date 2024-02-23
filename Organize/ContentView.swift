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
    private let logger = Logger(
        subsystem: OrganizeApp.bundleId, category: "ContentView")
    
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
        .environment(appModel)
        .sheet(isPresented: $appModel.showOnBoardingView) {
            NavigationStack {
                List {
                    
                }
                .navigationTitle("Forewords")
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Button {
                            
                        } label: {
                            HStack {
                                Text("Continue")
                                    .bold()
                            }
                            .padding(8)
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.bottom)
                    }
                }
                
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Space.self, inMemory: true)
}
