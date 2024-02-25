//
//  CubicObjectCaptureView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/4/24.
//

import Dispatch
import Foundation
import RealityKit
import SwiftUI
import SwiftData
import os

#if !(targetEnvironment(simulator) || targetEnvironment(macCatalyst))
struct CubicObjectCaptureView: View {
    @EnvironmentObject var objectCaptureModel: ObjectCaptureDataModel
    @Environment(\.modelContext) private var modelContext
    @Environment(CaptureViewModel.self) private var captureViewModel
    @Environment(AppViewModel.self) private var appModel
    
    @Query private var storages: [Storage]
    
    private var selectedStorages: [Storage] {
        storages.filter { appModel.storageListSelectionsIDs.contains($0.id)}
    }
    
    var session: ObjectCaptureSession
    
    // Pauses the scanning and shows tutorial pages. This sample passes it as
    // a binding to the two views so buttons can change the state.
    @State private var showInfo: Bool = false
    @State private var showOnboardingView: Bool = false
    
    var body: some View {
        @Bindable var captureViewModel = captureViewModel
        ZStack {
            ObjectCaptureView(session: session) {
                GradientBackground()
            }
            .blur(radius: objectCaptureModel.showPreviewModel ? 45 : 0)
            .transition(.opacity)
            if shouldShowOverlayView {
                CaptureOverlayView(session: session, showInfo: $showInfo)
            }
        }
        .sheet(isPresented: $captureViewModel.showCreateForm) {
            let target = Binding {
                captureViewModel.item
            } set: { newItemValue in
                captureViewModel.item = newItemValue
            }
            
            FormEditView(
                target, mode: .add,
                unsafePlacementSelectionID: captureViewModel.storageSelectionID
            ) {
                withAnimation {
                    captureViewModel.showCreateForm = false
                }
            } confirm: {
                withAnimation {
                    captureViewModel.showCreateForm = false
                }
                modelContext.insert(captureViewModel.item)
                try? modelContext.save()
                captureViewModel.item = Item(name: "My Item") 
            }
            .task {
                if let storageSelection = selectedStorages.first {
                    storageSelection.items.append(captureViewModel.item)
                }
            }
        }
        .sheet(isPresented: $showInfo) {
            HelpPageView(showInfo: $showInfo)
                .padding()
        }
        .sheet(isPresented: $showOnboardingView) { [weak objectCaptureModel] in
            objectCaptureModel?.setPreviewModelState(shown: false)
        } content: { [weak objectCaptureModel] in
            if let objectCaptureModel = objectCaptureModel,
               let onboardingState = objectCaptureModel.determineCurrentOnboardingState() {
                ObjectCaptureOnboardingView(state: onboardingState)
            }
        }
        .task {
            for await userCompletedScanPass in session.userCompletedScanPassUpdates where userCompletedScanPass {
                    objectCaptureModel.setPreviewModelState(shown: true)
            }
        }
        .onChange(of: objectCaptureModel.showPreviewModel) {_, showPreviewModel in
            if !showInfo {
                showOnboardingView = showPreviewModel
            }
        }
        .onChange(of: showInfo) {
            objectCaptureModel.setPreviewModelState(shown: showInfo)
        }
        .onAppear {
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
        }
        .id(session.id)
    }
    
    private var shouldShowOverlayView: Bool {
        !showInfo && 
        !objectCaptureModel.showPreviewModel &&
        !session.isPaused &&
        session.cameraTracking == .normal
    }
}

private struct GradientBackground: View {
    private let gradient = LinearGradient(
        colors: [.black.opacity(0.4), .clear],
        startPoint: .top,
        endPoint: .bottom
    )
    private let frameHeight: CGFloat = 300

    var body: some View {
        VStack {
            gradient
                .frame(height: frameHeight)

            Spacer()

            gradient
                .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
                .frame(height: frameHeight)
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
}
#endif
