//
//  CameraViewModel.swift
//  Organize
//
//  Created by Yuhao Chen on 2/24/24.
//

import SwiftUI
import Observation
import AVFoundation
import OSLog

@Observable class CameraDataModel: NSObject, AVCapturePhotoCaptureDelegate {
    //var path = NavigationPath()
    var picture: UIImage?
    var flashMode : AVCaptureDevice.FlashMode = .auto
    @ObservationIgnored var cameraView: CameraPreviewContainer!
    @ObservationIgnored var viewData: CameraViewData!
    var alertError : AlertError?
    var shouldShowAlertView = false
    var isCameraUnavailable = true
    
    private let videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [ .builtInDualCamera, .builtInTelephotoCamera, .builtInWideAngleCamera, .builtInTripleCamera, .builtInUltraWideCamera,  .builtInTrueDepthCamera, .continuityCamera, .external], mediaType: .video, position: .unspecified)
    private var allCaptureDevices: [AVCaptureDevice] {
        videoDeviceDiscoverySession.devices
    }
    
    private var frontCaptureDevices: [AVCaptureDevice] {
        allCaptureDevices
            .filter { $0.position == .front }
    }
    
    private var backCaptureDevices: [AVCaptureDevice] {
        allCaptureDevices
            .filter { $0.position == .back }
    }
    
    private var deviceInput : AVCaptureDeviceInput?
    
    override init() {
        cameraView = CameraPreviewContainer()
        viewData = CameraViewData()
    }
    
    @discardableResult
    public func checkForPermissions() -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            logger.info("Camera access authorized.")
            return true
        case .notDetermined:
            logger.warning("Camera access not determined")
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if !granted {
                    self.isCameraUnavailable = true
                } else {
                    self.isCameraUnavailable = false
                }
            }
            return false
        case .restricted:
            logger.warning("Camera access restricted")
            sendNoCameraAccessAlert()
            isCameraUnavailable = true
            return false
        case .denied:
            logger.warning("Camera access denied")
            sendNoCameraAccessAlert()
            isCameraUnavailable = true
            return false
        @unknown default:
            isCameraUnavailable = true
            return false
        }
    }
    private func sendNoCameraAccessAlert() {
        DispatchQueue.main.async {
            self.alertError = AlertError(title: "Camera Access", message: "Rainbow Journal" + " doesn't have access to use your camera, please update your privacy settings.", primaryButtonTitle: "Settings", secondaryButtonTitle: nil, primaryAction: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
                                          options: [:], completionHandler: nil)
                
            }, secondaryAction: nil)
            self.shouldShowAlertView = true
        }
    }
    
    func getAuthorization() async {
        let granted = await AVCaptureDevice.requestAccess(for: .video)
        await MainActor.run {
            if granted {
                self.configureSession()
            } else {
                logger.warning("Camera Not Authorized")
            }
        }
    }
    func configureSession() {
        viewData.captureSession = AVCaptureSession()
        
        // Check wether first time setting up camera, if so set capture device to a back camera, else set to system preference
        let userDefault = UserDefaults.standard
        if !userDefault.bool(forKey: "SetInitialUserPreferredCamera") {
            viewData.captureDevice = backCaptureDevices.first
        } else {
            viewData.captureDevice = AVCaptureDevice.systemPreferredCamera
        }
        
        if let _ = try? viewData.captureDevice?.lockForConfiguration() {
            viewData.captureDevice?.isSubjectAreaChangeMonitoringEnabled = true
            viewData.captureDevice?.unlockForConfiguration()
        }
        
        if let device = viewData.captureDevice {
            deviceInput = try? AVCaptureDeviceInput(device: device)
        }
        
        if let device = viewData.captureDevice, let input = deviceInput {
            // change video device if the current one disconnect
            //TODO: support capture device auto selection in future https://developer.apple.com/wwdc23/10106
            viewData.videoDeviceIsConnectedObservation = device.observe(\.isConnected) { _, change in
                guard let isConnected = change.newValue else { return }
                
                if !isConnected {
                    DispatchQueue.main.async {
                        self.changeCamera()
                    }
                }
            }
            viewData.captureSession?.addInput(input)
            
            viewData.stillImage = AVCapturePhotoOutput()
            if viewData.stillImage != nil {
                viewData.captureSession?.addOutput(viewData.stillImage!)
                if let max = viewData.captureDevice?.activeFormat.supportedMaxPhotoDimensions.last {
                    viewData.stillImage?.maxPhotoDimensions = max
                }
            }
            
            startCamera()
        } else {
            logger.warning("Couldn't configure session")
        }
    }
    func startCamera() {
        let previewLayer = cameraView.view.layer as? AVCaptureVideoPreviewLayer
        previewLayer?.session = viewData.captureSession
        
        if let device = viewData.captureDevice, let preview = previewLayer {
            viewData.rotationCoordinator = AVCaptureDevice.RotationCoordinator(device: device, previewLayer: preview)
            preview.connection?.videoRotationAngle = viewData.rotationCoordinator!.videoRotationAngleForHorizonLevelPreview
            
            viewData.previewObservation = viewData.rotationCoordinator!.observe(\.videoRotationAngleForHorizonLevelPreview, changeHandler: { old, value in
                preview.connection?.videoRotationAngle = self.viewData.rotationCoordinator!.videoRotationAngleForHorizonLevelPreview
            })
        }
        Task(priority: .background) {
            viewData.captureSession?.startRunning()
        }
    }
    func stopCamera() {
        viewData.captureSession?.stopRunning()
    }
    func changeCamera() {
        guard let currentCaptureDevice = viewData.captureDevice, let currentDeviceInput = deviceInput, let captureSession = viewData.captureSession else {
            return
        }
        
        defer {
            captureSession.beginConfiguration()
            captureSession.removeInput(currentDeviceInput)
            
            if let _ = try? viewData.captureDevice?.lockForConfiguration() {
                viewData.captureDevice?.isSubjectAreaChangeMonitoringEnabled = true
                viewData.captureDevice?.unlockForConfiguration()
            }
            
            if let device = viewData.captureDevice {
                deviceInput = try? AVCaptureDeviceInput(device: device)
                
            }
            
            if let input = deviceInput,
               captureSession.canAddInput(input) {
                captureSession.addInput(input)
            } else {
                captureSession.addInput(currentDeviceInput)
            }
            
            // Reset capture device to match input
            viewData.captureDevice = deviceInput?.device
            // Help system learn user peference
            AVCaptureDevice.userPreferredCamera = viewData.captureDevice
            
            if let max = viewData.captureDevice?.activeFormat.supportedMaxPhotoDimensions.last {
                viewData.stillImage?.maxPhotoDimensions = max
            }
            
            captureSession.commitConfiguration()
            
        }
        
        // Change to system prefer camera if current selection is defer from it
        if currentCaptureDevice != AVCaptureDevice.systemPreferredCamera {
            viewData.captureDevice = AVCaptureDevice.systemPreferredCamera
            return
        }
        
        let currentPosition = currentCaptureDevice.position
        switch currentPosition {
        case .unspecified, .front:
            viewData.captureDevice = self.backCaptureDevices.first
            return
        case .back:
            viewData.captureDevice = self.frontCaptureDevices.first
            return
        @unknown default:
            logger.warning("Unknown capture position. Defaulting to back cameras")
            viewData.captureDevice = self.backCaptureDevices.first
            return
        }
    }
    func set(zoom: CGFloat) {
        let factor = zoom < 1 ? 1 : zoom
        guard let device = deviceInput?.device else {
            logger.warning("Failed to set zoom because video device input is missing.")
            return
        }
        
        do {
            try device.lockForConfiguration()
            device.videoZoomFactor = factor
            device.unlockForConfiguration()
        } catch {
            logger.warning("Failed to set zoom because device couldn't be locked: \(error.localizedDescription)")
        }
    }
    func takePicture() {
        let settings = AVCapturePhotoSettings()
        if let max = viewData.captureDevice?.activeFormat.supportedMaxPhotoDimensions.last {
            settings.maxPhotoDimensions = max
        }
        if let captureDevice = viewData.captureDevice, captureDevice.hasFlash {
            settings.flashMode = flashMode
        }
        viewData.stillImage?.capturePhoto(with: settings, delegate: self)
    }
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let scale = scene?.screen.scale ?? 1
        let orientationAngle = viewData.rotationCoordinator!.videoRotationAngleForHorizonLevelCapture
        var imageOrientation: UIImage.Orientation!
        switch orientationAngle {
        case 90.0:
            imageOrientation = .right
        case 270.0:
            imageOrientation = .left
        case 0.0:
            imageOrientation = .up
        case 180.0:
            imageOrientation = .down
        default:
            imageOrientation = .right
        }
        if let imageData = photo.cgImageRepresentation() {
            picture = UIImage(cgImage: imageData, scale: scale, orientation: imageOrientation)
            //path = NavigationPath()
        }
    }
}



fileprivate let logger = Logger(subsystem: OrganizeApp.bundleId, category: "CameraViewModel")
