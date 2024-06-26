//
//  CaptureViewModel.swift
//  Organize
//
//  Created by Yuhao Chen on 2/4/24.
//

import Foundation
import Observation

@Observable
final class CaptureViewModel {
    var showErrorAlert: Bool = false
    var showReconstructionView: Bool = false
    var item: Item = Item(name: "My Item")
    var storageSelectionID: UUID?
    var showCreateForm = false
}
