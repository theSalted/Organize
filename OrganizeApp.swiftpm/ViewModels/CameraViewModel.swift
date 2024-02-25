//
//  CameraViewModel.swift
//  Organize
//
//  Created by Yuhao Chen on 2/24/24.
//

import Foundation
import Observation
import UIKit

@Observable
final class CameraViewModel {
    var showCamera = false
    var capturedImage: UIImage?
}
