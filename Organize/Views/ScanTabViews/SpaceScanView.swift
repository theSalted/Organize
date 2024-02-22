//
//  SpaceScanView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/19/24.
//

import SwiftUI
import OSLog
import SceneKit.ModelIO
import RoomPlan
import SceneKit

struct SpaceScanView: View {
    @EnvironmentObject var spaceScanViewModel: SpaceScanViewModel
    @Environment(AppViewModel.self) private var appModel
    @Environment(\.modelContext) private var modelContext
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
                                createSpaceAndStorages()
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
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbarColorScheme(.dark, for: .navigationBar)
            }
            .sheet(isPresented:$showCreateSpaceForm) {
                FormEditView($spaceScanViewModel.space) {
                    withAnimation {
                        showCreateSpaceForm = false
                    }
                } confirm: {
                    withAnimation {
                        showCreateSpaceForm = false
                        modelContext.insert(spaceScanViewModel.space)
                    }
                    try? modelContext.save()
                }

            }
            .sheet(isPresented: $spaceScanViewModel.showShareSheet) {
                ActivityViewControllerRepresentable(items: [spaceScanViewModel.exportURL])
            }
        }
    }
    
    private func createSpaceAndStorages() {
        spaceScanViewModel.actions.send(.stopSession)
        spaceScanViewModel.actions.send(.export)
        let capturedRoomObjects = spaceScanViewModel.capturedRoom?.objects
        let space = Space(name: spaceScanViewModel.name)
        
        var storages: [Storage] {
            guard let capturedRoomObjects else {
                return []
            }
            var output = [Storage]()
            for object in capturedRoomObjects {
                let storage = Storage(name: object.category.getName())
                // Save before insert because insert multiple storages into model context in single frame causes an uncaught NSException related to CoreData, but not inserting storages to model also crashes application when trying to read a space that contains these storages.
                try? modelContext.save()
                modelContext.insert(storage)
                output.append(storage)
            }
            return output
        }
        
        space.storages = storages
        spaceScanViewModel.space = space
        withAnimation {
            showCreateSpaceForm = true
        }
    }
}

#Preview {
    SpaceScanView()
        .environmentObject(SpaceScanViewModel())
}

fileprivate let logger = Logger(subsystem: OrganizeApp.bundleId, category: "SpaceScanViewModel")
