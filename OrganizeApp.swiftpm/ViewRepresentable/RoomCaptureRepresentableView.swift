//
//  RoomCaptureRepresentableView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/19/24.
//

import Foundation
import SwiftUI

struct RoomCaptureRepresentableView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: SpaceScanViewModel
    
    func makeUIViewController(context: Context) -> RoomCaptureViewController {
        return RoomCaptureViewController(viewModel: viewModel)
    }
    
    func updateUIViewController(_ uiViewController: RoomCaptureViewController, context: Context) {}
}
