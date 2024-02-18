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
        NavigationStack {
            RoomCaptureRepresentableView(viewModel: spaceScanViewModel)
                .onAppear {
                    spaceScanViewModel.actions.send(.startSession)
                }
                .onDisappear {
                    #warning("Need a pause")
                }
        }
    }
}

#Preview {
    SpaceScanView()
        .environmentObject(SpaceScanViewModel())
}

fileprivate let logger = Logger(subsystem: OrganizeApp.bundleId, category: "SpaceScanViewModel")
