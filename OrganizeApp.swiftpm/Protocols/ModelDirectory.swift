//
//  ModelDirectory.swift
//  Organize
//
//  Created by Yuhao Chen on 2/3/24.
//

import Foundation
import UIKit

protocol ModelDirectory {
    /// URL for root folder of captured object.
    var capturedObjectRootURL:  URL?        { get }
    /// URL for the 3D model file (usually .usdz or .obj)
    var modelURL:               URL?        { get }
    /// URL for the images used for 3D reconstruction
    var imageFolderURL:         URL?        { get }
    /// URL for the temporary snapshots used for 3D reconstruction
    var snapshotsFolderURL:     URL?        { get }
    /// URL that pointing to the the **folder** that contains the 3D model
    ///
    /// - Warning:
    /// This points to the **folder** that contains the 3D model.
    /// Use ``modelURL`` if you want to access the 3D model.
    var modelsFolderURL:        URL?        { get }
}
