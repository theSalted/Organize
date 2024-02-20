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
    @Environment(AppViewModel.self) private var appModel
    @State private var showCreateSpaceForm = false
    
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
                    .navigationTitle($spaceScanViewModel.name)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Next") {
                                spaceScanViewModel.actions.send(.export)
                                
                            }
                            .disabled(!spaceScanViewModel.canExport)
                        }
                        ToolbarItem(placement: .primaryAction) {
                            Button {
                                withAnimation {
                                    spaceScanViewModel.actions.send(.share)
                                }
                            } label: {
                                Label("Share", systemImage: "square.and.arrow.up")
                            }
                            .disabled(!spaceScanViewModel.canExport)
                        }
                    }
            }
            .sheet(isPresented: $spaceScanViewModel.showShareSheet) {
                ActivityViewControllerRepresentable(items: [spaceScanViewModel.exportURL])
            }
        }
//        .sheet(isPresented: $showCreateSpaceForm) {
//            @State var space = Space(name: spaceScanViewModel.name)
//
//            
//        }
    }
}

#Preview {
    SpaceScanView()
        .environmentObject(SpaceScanViewModel())
}

fileprivate let logger = Logger(subsystem: OrganizeApp.bundleId, category: "SpaceScanViewModel")
