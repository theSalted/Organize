//
//  RoomCaptureViewController+RoomCaptureSessionDelegate.swift
//  Organize
//
//  Created by Yuhao Chen on 2/19/24.
//

import Foundation
import RoomPlan
import SwiftUI

extension RoomCaptureViewController: RoomCaptureSessionDelegate {
    func captureSession(_ session: RoomCaptureSession, didUpdate room: CapturedRoom) {
        viewModel.capturedRoom = room
        DispatchQueue.main.async {
            withAnimation {
                self.viewModel.canExport = true
            }
        }
    }
}
