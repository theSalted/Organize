//
//  AppDataModel.swift
//  Storage
//
//  Created by Yuhao Chen on 1/22/24.
//

import Foundation

@Observable
class AppDataModel {
    private var _tabViewSelection : TabViewTag = .storage
    var tabViewSelection : String {
        get {
            _tabViewSelection.rawValue
        }
        set {
            _tabViewSelection = TabViewTag(rawValue: newValue) ?? .storage
        }
    }
    
    enum TabViewTag : String {
        case storage, scan
    }
}
