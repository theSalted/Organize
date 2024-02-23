//
//  RoomCaptureViewController.swift
//  Organize
//
//  Created by Yuhao Chen on 2/19/24.
//

import UIKit
import OSLog
import Combine
import RoomPlan
import SwiftUI

final class RoomCaptureViewController: UIViewController {
    var viewModel: SpaceScanViewModel
    private var cancellables: Set<AnyCancellable> = []
    private var roomScanView: RoomCaptureView?
    
    init(viewModel: SpaceScanViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let roomCaptureView = RoomCaptureView(frame: .zero)
        roomCaptureView.translatesAutoresizingMaskIntoConstraints = false
        self.roomScanView = roomCaptureView
        view.addSubview(roomCaptureView)
        NSLayoutConstraint.activate([
            roomCaptureView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            roomCaptureView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            roomCaptureView.topAnchor.constraint(equalTo: view.topAnchor),
            roomCaptureView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        setup()
        roomCaptureView.captureSession.delegate = self
    }
    
    private func setup() {
        viewModel.actions
            .sink { [weak self] action in
                switch action {
                case .startSession:
                    self?.startSession()
                case .stopSession:
                    self?.stopSession()
                case .share:
                    self?.shareModel()
                case .export:
                    self?.exportModel()
                }
            }
            .store(in: &cancellables)
    }
    
    private func startSession() {
        let sessionConfig = RoomCaptureSession.Configuration()
        roomScanView?.captureSession.run(configuration: sessionConfig)
    }
    
    private func stopSession() {
        roomScanView?.captureSession.stop()
    }
    
    private func exportModel() {
        exportMetadata()
        do {
            try viewModel.capturedRoom?.export(
                to: viewModel.exportURL,
                metadataURL: viewModel.metadataURL)
        } catch {
            logger.warning("Error when exporting room scan to usdz \(error)")
        }
    }
    
    private func exportMetadata() {
        do {
            guard let room = viewModel.capturedRoom else {
                return
            }
            let encoder = JSONEncoder()
            let data = try encoder.encode(room)
            try data.write(to: viewModel.metadataURL)
        } catch {
            logger.warning("Error when exporting metadata")
        }
    }
    
    private func shareModel() {
        exportModel()
        withAnimation {
            viewModel.showShareSheet = true
        }
    }
}

fileprivate let logger = Logger(subsystem: OrganizeApp.bundleId, category: "RoomCaptureViewController")
