//
//  AppViewModel.swift
//  Storage
//
//  Created by Yuhao Chen on 1/22/24.
//

import Foundation

@Observable
class AppViewModel {
    var tabViewSelection : TabViewTag = .storage
    var spaceListSelections : Set<Space.ID> = []
    var storageListSelections : Set<Storage.ID> = []
    
    enum TabViewTag : String, CaseIterable {
        case storage, scan
    }
}
