//
//  AppViewModel.swift
//  Organize
//
//  Created by Yuhao Chen on 1/22/24.
//

import Foundation
import Observation
import SwiftUI

@Observable
final class AppViewModel {
    var tabViewSelection: TabViewTag = .organize
    
    // MARK: Selection IDs for lists
    var spaceListSelectionIDs: Set<Space.ID> = [] {
        didSet { storageListSelectionsIDs = [] }
    }
    
    var storageListSelectionsIDs: Set<Storage.ID> = [] {
        didSet { itemsListSelectionIDs = [] }
    }
    
    var itemsListSelectionIDs: Set<Item.ID> = []
    
    var detailSelections: Set<AnyHashable> = []
    
    var showOnBoardingView = true
    
    enum TabViewTag: String, CaseIterable {
        case organize, capture, scan
    }
    
    enum DetailsViewCategory  {
        case space, storage, item
    }
}
