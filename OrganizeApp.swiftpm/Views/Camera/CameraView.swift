//
//  CameraView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/24/24.
//

import SwiftUI
import PhotosUI

struct CameraView: View {
    typealias ButtonAction = () -> Void
    
    @Environment(CameraDataModel.self) private var cameraData
    @Environment(CameraViewModel.self) private var cameraViewModel
    
    @State var currentZoomFactor: CGFloat = 1.0
    @GestureState private var pinchMagnification: CGFloat = 1
    @State var selectedItem : PhotosPickerItem?
        
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            ProgressView()
            
            #if targetEnvironment(simulator)
            if let image = cameraData.picture {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            }
            #else
            cameraData.cameraView
                .overlay {
//                    if model.isCameraUnavailable {
//                        Text("Camera Unavailable")
//                            .font(.title)
//                            .foregroundStyle(.white)
//                    }
                }
                .gesture(MagnificationGesture()
                    .updating($pinchMagnification, body: { (value, state, _) in
                        state = value
                        cameraData.set(zoom: currentZoomFactor * pinchMagnification)
                    })
                        .onEnded{ self.currentZoomFactor *= $0 }
                )
                .onDisappear {
                    cameraData.viewData.previewObservation = nil
                    cameraData.stopCamera()
                }
                .task {
                   await cameraData.getAuthorization()
                }
                .onChange(of: cameraData.picture) { _, newValue in
                    if let photo = newValue {
                        withAnimation {
                            cameraViewModel.capturedImage = photo
                            cameraViewModel.showCamera = false
                        }
                    }
                }
            #endif
            Spacer()
                .frame(minHeight: 200)
                .ignoresSafeArea()
                .safeAreaInset(edge: .bottom) {
                    HStack {
                        capturedPhotoThumbnail
                        
                        Spacer()
                        
                        captureButton
                        
                        Spacer()
                        
                        flipCameraButton
                        
                    }
                    .padding()
                    .background(.bar)
                    
                }
                .safeAreaInset(edge: .top) {
                    ZStack {
                        Spacer()
                        flashModeButton
                        HStack {
                            Spacer()
                            Button {
                                withAnimation {
                                    cameraViewModel.showCamera = false
                                }
                            } label: {
                                Text("Done")
                                    .foregroundStyle(.yellow)
                                    .fontWeight(.bold)
                            }
                        }
                    }
                    .padding()
                    .background(.bar)
                }
        }

    }
    
    var flashModeButton: some View {
        Button(action: {
            switch cameraData.flashMode {
            case .auto:
                cameraData.flashMode = .on
            case .on:
                cameraData.flashMode = .off
            case .off:
                cameraData.flashMode = .auto
            @unknown default:
                cameraData.flashMode = .auto
            }
            //model.switchFlash()
        }, label: {
            switch cameraData.flashMode {
            case .auto:
                Image(systemName: "bolt.badge.automatic.fill")
            case .on:
                Image(systemName: "bolt.fill")
            case .off:
                Image(systemName: "bolt.slash.fill")
            @unknown default:
                Image(systemName: "bolt.trianglebadge.exclamationmark")
            }
            
        })
        .font(.system(size: 20, weight: .medium, design: .default))
        .accentColor(cameraData.flashMode == .on ? .yellow : .white)
    }
    
    var captureButton: some View {
        Button("Snapshot") {
            cameraData.takePicture()
        }
        .buttonStyle(CaptureButtonStyle())
    }
    
    var capturedPhotoThumbnail: some View {
        PhotosPicker(selection: $selectedItem) {
            Group {
                if let image = cameraData.picture {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 60, maxHeight: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(maxWidth: 60, maxHeight: 60, alignment: .center)
                        .foregroundStyle(Color(uiColor: .secondarySystemBackground))
                        .overlay {
                            Image(systemName: "photo.fill")
                                .imageScale(.large)
                                .foregroundStyle(Color(uiColor: .secondaryLabel))
                        }
                }
            }
        }
        .onChange(of: selectedItem) { _, _ in
            guard let item = selectedItem else {
                return
            }
            
            item.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let data):
                    if let data, let photo = UIImage(data: data) {
                        DispatchQueue.main.async {
                            withAnimation {
                                #if targetEnvironment(simulator)
                                cameraData.picture = photo
                                #else
                                cameraViewModel.capturedImage = photo
                                cameraViewModel.showCamera = false
                                #endif
                            }
                        }
                    }
                case .failure(_):
                    return
                }
            }
        }
    }
    
    var flipCameraButton: some View {
        Button(action: {
            cameraData.changeCamera()
        }, label: {
            Circle()
                .foregroundColor(Color.gray.opacity(0.2))
                .frame(maxWidth: 45, maxHeight: 45, alignment: .center)
                .overlay(
                    Image(systemName: "camera.rotate.fill")
                        .foregroundColor(.white))
        })
    }

}
