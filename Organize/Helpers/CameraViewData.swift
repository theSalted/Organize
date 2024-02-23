//
//  CameraDataModel.swift
//  Organize
//
//  Created by Yuhao Chen on 2/24/24.
//

import Foundation
import AVFoundation

class CameraViewData {
    var captureDevice: AVCaptureDevice?
    var captureSession: AVCaptureSession?
    var stillImage: AVCapturePhotoOutput?
    var rotationCoordinator: AVCaptureDevice.RotationCoordinator?
    var previewObservation: NSKeyValueObservation?
    var videoDeviceIsConnectedObservation : NSKeyValueObservation?
}
