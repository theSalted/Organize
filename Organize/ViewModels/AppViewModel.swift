//
//  AppViewModel.swift
//  Organize
//
//  Created by Yuhao Chen on 1/22/24.
//

import Foundation
import Observation

@Observable
class AppViewModel {
    var tabViewSelection:       TabViewTag = .storage
    var spaceListSelections:    Set<Space.ID> =     []
    var storageListSelections:  Set<Storage.ID> =   []
    var itemsListSelections:    Set<Item.ID> =      []
    var detailSelections:       Set<AnyHashable> =  []
    
    enum TabViewTag: String, CaseIterable {
        case storage, scan
    }
    enum DetailsViewCategory  {
        case space, storage, item
    }
}
