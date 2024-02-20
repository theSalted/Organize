//
//  SpaceScanView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/19/24.
//

import SwiftUI
import OSLog

struct SpaceScanView: View {
    @EnvironmentObject var spaceScanViewModel: SpaceScanViewModel
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.black.gradient)
                .ignoresSafeArea()
            NavigationStack {
                RoomCaptureRepresentableView(viewModel: spaceScanViewModel)
                    .onAppear {
                        spaceScanViewModel.actions.send(.startSession)
                    }
                    .onDisappear {
                        spaceScanViewModel.actions.send(.stopSession)
                    }
            }
        }
    }
}

#Preview {
    SpaceScanView()
        .environmentObject(SpaceScanViewModel())
}

fileprivate let logger = Logger(subsystem: OrganizeApp.bundleId, category: "SpaceScanViewModel")
