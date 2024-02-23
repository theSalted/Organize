//
//  CameraPreviewContainer.swift
//  Organize
//
//  Created by Yuhao Chen on 2/24/24.
//

import Foundation
import SwiftUI
import AVFoundation

class CustomPreviewView: UIView {
   override class var layerClass: AnyClass {
       return AVCaptureVideoPreviewLayer.self
   }
}
struct CameraPreviewContainer: UIViewRepresentable {
   let view = CustomPreviewView()

   func makeUIView(context: Context) -> UIView {
      return view
   }
   func updateUIView(_ uiView: UIView, context: Context) { }
}
