//
//  SpaceScanViewModel.swift
//  Organize
//
//  Created by Yuhao Chen on 2/19/24.
//

import Combine
import Foundation
import RoomPlan

// TODO: Upgrade to using observation framework
class SpaceScanViewModel: ObservableObject {
    enum Action {
        case startSession
        case stopSession
        case share
        case export
    }
    
    // TODO: Is Combine really necessary here? I dislike an observer pattern sticking inside of MVVM pattern
    // TODO: These are really data models, URLs should be using the same filemanager system CapturedObject is using
    var actions = PassthroughSubject<Action, Never>();
    let exportURL = FileManager.default.temporaryDirectory.appending(path: "ScannedSpace.usdz")
    let metadataURL = FileManager.default.temporaryDirectory.appending(path: "ScannedSpace.json")
    
    @Published var canExport = false
    @Published var showShareSheet = false
    @Published var capturedRoom: CapturedRoom?
    @Published var name: String = "My Room"
    @Published var space = Space(name: "My Room")
}
